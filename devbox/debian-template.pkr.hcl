packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/qemu"
    }
    virtualbox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-13.3.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:c9f09d24b7e834e6834f2ffa565b33d6f1f540d04bd25c79ad9953bc79a8ac02"
}

variable "headless" {
  type    = bool
  default = false
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key installed for the devbox user."
  default     = "~/.ssh/id_ed25519.pub"

  validation {
    condition     = fileexists(pathexpand(var.ssh_public_key_path))
    error_message = "The SSH public key path must point to an existing public key file."
  }
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

source "qemu" "debian" {
  vm_name          = "debian.qcow2"
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  output_directory = "output/debian-qemu"
  http_directory   = "http"

  # 硬件
  cpus      = 2
  memory    = 2048
  disk_size = 20480

  # virtio 磁盘（preseed 里对应 /dev/vda）
  format         = "qcow2"
  accelerator    = "kvm"
  disk_cache     = "unsafe"
  disk_interface = "virtio"
  net_device     = "virtio-net"

  headless = var.headless

  # preseed 通过 Packer 内置 HTTP server 提供
  boot_wait = "8s"
  boot_command = [
    "<esc><wait3>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "auto=true priority=critical<enter><wait>"
  ]

  # DHCP，SSH 地址由 Packer 自动获取
  ssh_username = "devbox"
  ssh_password = "devbox"
  ssh_timeout  = var.ssh_timeout

  shutdown_command = "sudo bash -c 'passwd -l devbox && passwd -l root && shutdown -P now'"
}

source "virtualbox-iso" "debian" {
  vm_name              = "debian"
  iso_url              = var.iso_url
  iso_checksum         = var.iso_checksum
  guest_os_type        = "Debian_64"
  guest_additions_mode = "disable"
  output_directory     = "output/debian-virtualbox"
  http_directory       = "http"

  cpus                 = 2
  memory               = 2048
  disk_size            = 20480
  hard_drive_interface = "sata"
  headless             = var.headless

  boot_wait = "8s"
  boot_command = [
    "<esc><wait3>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "auto=true priority=critical<enter><wait>"
  ]

  ssh_username = "devbox"
  ssh_password = "devbox"
  ssh_timeout  = var.ssh_timeout

  shutdown_command = "sudo bash -c 'passwd -l devbox && passwd -l root && shutdown -P now'"
}

build {
  sources = ["source.qemu.debian", "source.virtualbox-iso.debian"]

  provisioner "shell" {
    pause_before    = "10s"
    script          = "scripts/setup-debian.sh"
    execute_command = "echo 'devbox' | sudo -S bash '{{ .Path }}'"
  }

  provisioner "file" {
    source      = pathexpand(var.ssh_public_key_path)
    destination = "/tmp/devbox.pub"
  }

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    inline = [
      "install -d -m 0700 -o devbox -g devbox /home/devbox/.ssh",
      "install -m 0600 -o devbox -g devbox /tmp/devbox.pub /home/devbox/.ssh/authorized_keys",
      "rm -f /tmp/devbox.pub",
    ]
  }

}
