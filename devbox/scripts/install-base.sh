#!/usr/bin/env bash

# stop on errors
set -euo pipefail

if [[ $PACKER_BUILDER_TYPE == "qemu" ]]; then
    DISK='/dev/vda'
else
    DISK='/dev/sda'
fi

FQDN='devbox-arch'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
PASSWORD="$(/usr/bin/openssl passwd -6 'devbox')"
TIMEZONE='UTC'

CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
ROOT_PARTITION="${DISK}1"
TARGET_DIR='/mnt'
COUNTRY="${COUNTRY:-US}"
MIRRORLIST="https://archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

echo ">>>> install-base.sh: Clearing partition table on ${DISK}.."
/usr/bin/sgdisk --zap "${DISK}"

echo ">>>> install-base.sh: Destroying magic strings and signatures on ${DISK}.."
/usr/bin/dd if=/dev/zero "of=${DISK}" bs=512 count=2048
/usr/bin/wipefs --all "${DISK}"

echo ">>>> install-base.sh: Creating /root partition on ${DISK}.."
/usr/bin/sgdisk --new=1:0:0 "${DISK}"

echo ">>>> install-base.sh: Setting ${DISK} bootable.."
/usr/bin/sgdisk "${DISK}" --attributes=1:set:2

echo ">>>> install-base.sh: Creating /root filesystem (ext4).."
/usr/bin/mkfs.ext4 -O ^64bit -F -m 0 -q -L root "${ROOT_PARTITION}"

echo ">>>> install-base.sh: Mounting ${ROOT_PARTITION} to ${TARGET_DIR}.."
/usr/bin/mount -o noatime,errors=remount-ro "${ROOT_PARTITION}" "${TARGET_DIR}"

echo ">>>> install-base.sh: Setting pacman ${COUNTRY} mirrors.."
curl -s "$MIRRORLIST" | sed 's/^#Server/Server/' >/etc/pacman.d/mirrorlist

echo ">>>> install-base.sh: Bootstrapping the base installation.."
/usr/bin/pacstrap "${TARGET_DIR}" base base-devel linux

echo ">>>> install-base.sh: Installing basic packages.."
/usr/bin/arch-chroot "${TARGET_DIR}" pacman -S --noconfirm gptfdisk openssh syslinux dhcpcd

echo ">>>> install-base.sh: Configuring syslinux.."
/usr/bin/arch-chroot ${TARGET_DIR} syslinux-install_update -i -a -m
/usr/bin/sed -i "s|sda3|${ROOT_PARTITION##/dev/}|" "${TARGET_DIR}/boot/syslinux/syslinux.cfg"
/usr/bin/sed -i 's/TIMEOUT 50/TIMEOUT 10/' "${TARGET_DIR}/boot/syslinux/syslinux.cfg"

echo ">>>> install-base.sh: Generating the filesystem table.."
/usr/bin/genfstab -p "${TARGET_DIR}" >>"${TARGET_DIR}/etc/fstab"

echo ">>>> install-base.sh: Generating the system configuration script.."
/usr/bin/install --mode=0755 /dev/null "${TARGET_DIR}${CONFIG_SCRIPT}"

CONFIG_SCRIPT_SHORT="$(basename "$CONFIG_SCRIPT")"
cat <<-EOF >"${TARGET_DIR}${CONFIG_SCRIPT}"
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring hostname, timezone, and keymap.."
  echo '${FQDN}' > /etc/hostname
  /usr/bin/ln -s '/usr/share/zoneinfo/${TIMEZONE}' /etc/localtime
  echo 'KEYMAP=${KEYMAP}' > /etc/vconsole.conf
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring locale.."
  /usr/bin/sed -i 's/#${LANGUAGE}/${LANGUAGE}/' /etc/locale.gen
  /usr/bin/locale-gen
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Creating initramfs.."
  /usr/bin/mkinitcpio -p linux
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Setting root pasword.."
  /usr/bin/usermod --password '${PASSWORD}' root
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring network.."
  # Disable systemd Predictable Network Interface Names and revert to traditional interface names
  # https://wiki.archlinux.org/index.php/Network_configuration#Revert_to_traditional_interface_names
  /usr/bin/ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
  /usr/bin/systemctl enable dhcpcd@eth0.service
  /usr/bin/systemctl enable systemd-resolved.service
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring sshd.."
  /usr/bin/sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
  /usr/bin/systemctl enable sshd.service

  # Workaround for https://bugs.archlinux.org/task/58355 which prevents sshd to accept connections after reboot
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Adding workaround for sshd connection issue after reboot.."
  /usr/bin/pacman -S --noconfirm rng-tools
  /usr/bin/systemctl enable rngd

  # Development user for Packer provisioning
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Creating devbox user.."
  /usr/bin/useradd --password '${PASSWORD}' --comment 'DevBox User' --create-home --user-group devbox
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring sudo.."
  echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/10_devbox
  echo 'devbox ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_devbox
  /usr/bin/chmod 0440 /etc/sudoers.d/10_devbox

  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Cleaning up.."
  /usr/bin/pacman -Rcns --noconfirm gptfdisk
EOF

echo ">>>> install-base.sh: Entering chroot and configuring system.."
/usr/bin/arch-chroot "${TARGET_DIR}" "${CONFIG_SCRIPT}"
rm "${TARGET_DIR}${CONFIG_SCRIPT}"

# http://comments.gmane.org/gmane.linux.arch.general/48739
echo ">>>> install-base.sh: Adding workaround for shutdown race condition.."
/usr/bin/install --mode=0644 /root/poweroff.timer "${TARGET_DIR}/etc/systemd/system/poweroff.timer"

echo ">>>> install-base.sh: Completing installation.."
/usr/bin/sleep 3
/usr/bin/umount "${TARGET_DIR}"
# Turning network interfaces down to make sure SSH session was dropped on host.
# More info at: https://www.packer.io/docs/provisioners/shell.html#handling-reboots
echo '==> Turning down network interfaces and rebooting'
for i in $(/usr/bin/ip -o link show | /usr/bin/awk -F': ' '{print $2}'); do /usr/bin/ip link set "${i}" down; done
/usr/bin/systemctl reboot
echo ">>>> install-base.sh: Installation complete!"
