terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "= 0.9.9"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.9"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

resource "libvirt_volume" "system" {
  name = "${var.vm_name}.qcow2"
  pool = var.pool

  target = {
    format = { type = "qcow2" }
  }

  create = {
    content = { url = abspath(var.image_path) }
  }
}

resource "libvirt_cloudinit_disk" "seed" {
  name = "${var.vm_name}-seed"
  meta_data = yamlencode({
    instance-id    = var.vm_name
    local-hostname = var.vm_name
  })
  user_data = "#cloud-config\n${yamlencode({
    ssh_pwauth     = false
    ssh_deletekeys = true
    # 启用串口登录提示；账户密码需先通过 SSH 设置。
    runcmd = [["systemctl", "enable", "--now", "serial-getty@ttyS0.service"]]
    users = [{
      name                = "devbox"
      lock_passwd         = true
      sudo                = "ALL=(ALL) NOPASSWD:ALL"
      ssh_authorized_keys = [trimspace(file(pathexpand(var.ssh_public_key_path)))]
    }]
  })}"
}

resource "libvirt_volume" "seed" {
  name = "${var.vm_name}-seed.iso"
  pool = var.pool

  target = {
    format = { type = "iso" }
  }

  create = {
    content = { url = libvirt_cloudinit_disk.seed.path }
  }
}

resource "libvirt_domain" "arch" {
  name        = var.vm_name
  type        = "kvm"
  running     = true
  memory      = var.memory_mib
  memory_unit = "MiB"
  vcpu        = var.vcpu

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    boot_devices = [{ dev = "hd" }]
  }

  devices = {
    disks = [
      {
        driver = { name = "qemu", type = "qcow2" }
        source = {
          volume = {
            pool   = var.pool
            volume = libvirt_volume.system.name
          }
        }
        target = { dev = "vda", bus = "virtio" }
      },
      {
        device = "cdrom"
        driver = { name = "qemu", type = "raw" }
        source = {
          volume = {
            pool   = var.pool
            volume = libvirt_volume.seed.name
          }
        }
        target = { dev = "sda", bus = "sata" }
      },
    ]
    interfaces = [{
      type  = "network"
      model = { type = "virtio" }
      wait_for_ip = {
        source  = "lease"
        timeout = 300
      }
      source = {
        network = { network = var.network }
      }
    }]
    # 为 virsh console 提供 ttyS0 串口。
    consoles = [{
      target = { type = "serial", port = 0 }
    }]
    # VNC 提供虚拟机图形显示
    graphics = [{
      vnc = { auto_port = true, listen = "127.0.0.1" }
    }]
    videos = [{
      model = { type = "virtio" }
    }]
  }
}

data "libvirt_domain_interface_addresses" "arch" {
  domain = libvirt_domain.arch.name
  source = "lease"
}

locals {
  vm_ipv4 = one(flatten([
    for interface in data.libvirt_domain_interface_addresses.arch.interfaces : [
      for address in interface.addrs : address.addr if address.type == "ipv4"
    ]
  ]))
}

resource "terraform_data" "ssh_include" {
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/ensure-ssh-include.sh"
  }
}

resource "local_file" "ssh_host" {
  filename             = pathexpand("~/.ssh/config.d/${var.vm_name}.conf")
  file_permission      = "0600"
  directory_permission = "0700"
  content              = <<-EOT
    Host ${var.vm_name}
        HostName ${local.vm_ipv4}
        User devbox
        IdentityFile ${trimsuffix(pathexpand(var.ssh_public_key_path), ".pub")}
        IdentitiesOnly yes
  EOT

  depends_on = [terraform_data.ssh_include]
}

output "vm_name" {
  value = libvirt_domain.arch.name
}
