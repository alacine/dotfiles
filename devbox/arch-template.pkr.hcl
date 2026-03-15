packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/qemu"
    }
    vmware = {
      version = ">= 2.1.0"
      source  = "github.com/vmware/vmware"
    }
    virtualbox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/virtualbox"
    }
    parallels = {
      version = ">= 1.2.8"
      source  = "github.com/Parallels/parallels"
    }
    vagrant = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

variable "iso_url" {
  type    = string
  default = "https://mirrors.kernel.org/archlinux/iso/latest/archlinux-x86_64.iso"
}

variable "iso_checksum_url" {
  type    = string
  default = "https://mirrors.kernel.org/archlinux/iso/latest/sha256sums.txt"
}

variable "ssh_timeout" {
  type    = string
  default = "20m"
}

variable "country" {
  type = string
  # default = "US"
  default = "CN"
}

variable "write_zeros" {
  type    = string
  default = "true"
}

variable "headless" {
  type    = bool
  default = false
}

source "parallels-iso" "arch" {
  parallels_tools_flavor = "lin"
  parallels_tools_mode   = "attach"
  guest_os_type          = "linux-2.6"
  iso_url                = var.iso_url
  iso_checksum           = "file:${var.iso_checksum_url}"
  http_directory         = "srv"
  boot_wait              = "5s"
  boot_command = [
    "<enter><wait10><wait10><wait10><wait10>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait5>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/poweroff.timer<enter><wait5>",
    "/usr/bin/bash ./enable-ssh.sh<enter>",
  ]
  cpus             = 1
  memory           = 1024
  disk_size        = 20480
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_timeout      = var.ssh_timeout
  shutdown_command = "sudo systemctl start poweroff.timer"
}

source "virtualbox-iso" "arch" {
  iso_url              = var.iso_url
  iso_checksum         = "file:${var.iso_checksum_url}"
  guest_os_type        = "ArchLinux_64"
  guest_additions_mode = "disable"
  output_directory     = "output-virtualbox"
  http_directory       = "srv"
  boot_wait            = "5s"
  boot_command = [
    "<enter><wait10><wait10><wait10><wait10>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait5>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/poweroff.timer<enter><wait5>",
    "/usr/bin/bash ./enable-ssh.sh<enter>",
  ]
  cpus                 = 1
  memory               = 1024
  disk_size            = 20480
  hard_drive_interface = "sata"
  ssh_username         = "vagrant"
  ssh_password         = "vagrant"
  ssh_timeout          = var.ssh_timeout
  shutdown_command     = "sudo systemctl start poweroff.timer"
  headless             = var.headless
}

source "vmware-iso" "arch" {
  iso_url        = var.iso_url
  iso_checksum   = "file:${var.iso_checksum_url}"
  http_directory = "srv"
  boot_wait      = "5s"
  boot_command = [
    "<enter><wait10><wait10><wait10><wait10>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait5>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/poweroff.timer<enter><wait5>",
    "/usr/bin/bash ./enable-ssh.sh<enter>",
  ]
  cpus                 = 1
  memory               = 1024
  disk_size            = 20480
  ssh_username         = "vagrant"
  ssh_password         = "vagrant"
  ssh_timeout          = var.ssh_timeout
  shutdown_command     = "sudo systemctl start poweroff.timer"
  headless             = var.headless
  network_adapter_type = "e1000"
}

source "qemu" "arch" {
  iso_url          = var.iso_url
  iso_checksum     = "file:${var.iso_checksum_url}"
  output_directory = "output-qemu"
  http_directory   = "srv"
  boot_wait        = "5s"
  boot_command = [
    "<enter><wait10><wait10><wait10><wait10><wait10><wait10>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait5>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/poweroff.timer<enter><wait5>",
    "/usr/bin/bash ./enable-ssh.sh<enter>",
  ]
  cpus             = 1
  memory           = 1024
  disk_size        = 20480
  format           = "qcow2"
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_timeout      = var.ssh_timeout
  shutdown_command = "sudo systemctl start poweroff.timer"
  headless         = var.headless

  accelerator = "kvm"
  # 构建期间关闭磁盘缓存安全检查（最明显的提速）
  # 构建过程不需要掉电安全，unsafe 比默认的 writeback 快很多，pacstrap 阶段写大量包时效果显著。
  disk_cache     = "unsafe"
  disk_interface = "virtio"
  net_device     = "virtio-net"
}

build {
  sources = [
    "source.parallels-iso.arch",
    "source.virtualbox-iso.arch",
    "source.vmware-iso.arch",
    "source.qemu.arch",
  ]

  provisioner "shell" {
    execute_command   = "{{ .Vars }} COUNTRY=${var.country} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    script            = "scripts/install-base.sh"
  }

  provisioner "shell" {
    only            = ["parallels-iso.arch"]
    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script          = "scripts/install-parallels.sh"
  }

  provisioner "shell" {
    only            = ["virtualbox-iso.arch"]
    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script          = "scripts/install-virtualbox.sh"
  }

  provisioner "shell" {
    only            = ["vmware-iso.arch"]
    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script          = "scripts/install-vmware.sh"
  }

  provisioner "shell" {
    execute_command = "{{ .Vars }} WRITE_ZEROS=${var.write_zeros} sudo -E -S bash '{{ .Path }}'"
    script          = "scripts/cleanup.sh"
  }

  post-processor "vagrant" {
    output = "output/arch_{{ .Provider }}-${formatdate("YYYY.MM", timestamp())}.box"
  }
}
