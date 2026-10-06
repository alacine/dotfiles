#!/bin/bash
set -euxo pipefail

# 基础包
apt-get update
apt-get install -y --no-install-recommends \
    sudo \
    wget \
    curl \
    ca-certificates \
    qemu-guest-agent \
    systemd-resolved

# 网络：用 systemd-networkd 替代 ifupdown
# 原因：/etc/network/interfaces 硬编码了构建时的接口名（如 ens3），
# 但 QEMU/libvirt 启动时接口名可能不同（如 enp1s0），导致 DHCP 不跑。
# systemd-networkd 用 Name=en* 匹配所有以太网接口，与名字无关。
cat >/etc/systemd/network/10-dhcp.network <<'EOF'
[Match]
Name=en*

[Network]
DHCP=yes
EOF

systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl disable networking 2>/dev/null || true

# systemd-resolved 管 DNS，/etc/resolv.conf 指向它的 stub resolver
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Passwordless sudo for the development user.
echo "devbox ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/devbox
chmod 0440 /etc/sudoers.d/devbox

# 清理
apt-get clean
rm -rf /var/lib/apt/lists/*
truncate -s 0 /root/.bash_history || true

# 填零压缩磁盘
dd if=/dev/zero of=/zero bs=1M 2>/dev/null || true
rm -f /zero
sync
