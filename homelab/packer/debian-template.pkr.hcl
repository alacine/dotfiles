packer {
  required_plugins {
    proxmox = {
      version = "~> 1.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_url" {
  type    = string
  default = "https://192.168.88.100:8006/api2/json"
}

variable "proxmox_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_token_secret" {
  type      = string
  sensitive = true
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-13.3.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:c9f09d24b7e834e6834f2ffa565b33d6f1f540d04bd25c79ad9953bc79a8ac02"
}

source "proxmox-iso" "debian" {
  # 连接
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_token_id
  token                    = var.proxmox_token_secret
  insecure_skip_tls_verify = true
  node                     = "pve"

  # VM 基本信息
  vm_name = "debian-13-template"
  os      = "l26"

  # ISO：Packer 会下载到 PVE local 存储，构建完自动卸载
  boot_iso {
    iso_url          = var.iso_url
    iso_checksum     = var.iso_checksum
    iso_storage_pool = "local"
    unmount          = true
  }

  # 固件：显式用 SeaBIOS（legacy BIOS），避免 UEFI 模式要求 EFI 分区
  bios = "seabios"

  # 硬件：模板只需要够安装系统的配置，clone 时 Terraform 会覆盖
  cores  = 2
  memory = 2048

  scsi_controller = "virtio-scsi-pci"

  disks {
    type         = "scsi"
    disk_size    = "8G"
    storage_pool = "local-lvm"
    # 丢弃未使用块，配合填零脚本压缩模板体积
    discard = true
  }

  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # 启用 QEMU guest agent socket（setup.sh 里会装软件包并 enable 服务）
  qemu_agent = true

  # preseed.cfg 通过 Packer 内置 HTTP server 提供给安装程序
  http_directory = "${path.root}/http"

  # 等待 VM 启动后发送 boot command
  boot_wait = "8s"
  boot_command = [
    "<esc><wait3>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "auto=true priority=critical<enter><wait>"
  ]

  # vmbr0 桥接有线网卡，VM 直接从路由器 DHCP 拿 IP，本机可直接访问
  # qemu_agent=true 让 packer 通过 guest agent 自动获取 VM IP
  ssh_username = "packer"
  ssh_password = "packer"
  ssh_timeout  = "40m"

  # 构建完转成模板
  template_name        = "debian-13-cloud"
  template_description = "Debian 13 (Trixie) cloud-init template, built by Packer"
}

build {
  sources = ["source.proxmox-iso.debian"]

  provisioner "shell" {
    # 等 cloud-init 之类的服务初始化完再执行
    pause_before = "10s"
    script       = "${path.root}/scripts/setup.sh"
    # packer 用户需要 sudo 执行脚本
    execute_command = "echo 'packer' | sudo -S bash '{{ .Path }}'"
  }
}
