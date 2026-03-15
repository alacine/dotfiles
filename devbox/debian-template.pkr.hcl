packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/qemu"
    }
    vagrant = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/vagrant"
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

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

source "qemu" "debian" {
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  output_directory = "output-debian"
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
  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_timeout  = var.ssh_timeout

  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
}

build {
  sources = ["source.qemu.debian"]

  provisioner "shell" {
    pause_before    = "10s"
    script          = "scripts/setup-debian.sh"
    execute_command = "echo 'vagrant' | sudo -S bash '{{ .Path }}'"
  }

  post-processor "vagrant" {
    output = "output/debian_{{.Provider}}-${formatdate("YYYY.MM", timestamp())}.box"
  }
}
