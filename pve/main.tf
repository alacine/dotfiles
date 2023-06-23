terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_debug            = true
  pm_user             = var.pm_user
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}

resource "local_file" "cloud_init_user_data_file" {
  content = templatefile(
    "${path.module}/cloud-inits/user_data.tftpl",
    {
      "name" : var.vm_user,
      "password" : var.vm_password,
      "public_key" : file(var.public_key_path)
    }
  )
  filename = "${path.module}/files/user_data.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  triggers = {
    user = var.pm_admin
    host = var.pm_host
  }

  connection {
    type = "ssh"
    #user = var.pm_admin
    user        = self.triggers.user
    private_key = file("~/.ssh/id_rsa")
    #host     = var.pm_host
    host = self.triggers.host
  }

  provisioner "remote-exec" {
    inline = ["mkdir -p /var/lib/vz/snippets/"]
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file.filename
    destination = "/var/lib/vz/snippets/user_data_vm.yml"
  }

  provisioner "remote-exec" {
    when   = destroy
    inline = ["rm -rf /var/lib/vz/snippets/"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "proxmox_vm_qemu" "srv" {
  depends_on = [
    null_resource.cloud_init_config_files,
  ]
  count = 1
  name  = "srv-${count.index + 1}"
  desc  = "Home Server"

  target_node = "pve"

  clone = "ubuntu-cloud-init"

  agent    = 1
  qemu_os  = "l26"
  os_type  = "ubuntu"
  onboot   = true
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    #slot     = 0
    size    = "200G"
    type    = "scsi"
    storage = "local-lvm"
    #iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  ipconfig0 = "ip=192.168.31.${count.index + 100}/24,gw=192.168.31.1"

  cicustom = "user=local:snippets/user_data_vm.yml"
}

resource "null_resource" "refresh_ssh_config" {
  depends_on = [
    proxmox_vm_qemu.srv,
  ]

  provisioner "local-exec" {
    command = <<EOF
      ssh-keygen -R 192.168.31.100
      ssh-keyscan 192.168.31.100 >> ~/.ssh/known_hosts
    EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
      ssh-keygen -R 192.168.31.100
    EOF
  }
}

resource "null_resource" "setup_server" {
  provisioner "local-exec" {
    command = <<EOF
      ansible-playbook \
        --connection=ssh \
        --inventory=${local_file.inventory.filename} \
        playbook/server.yml
    EOF
  }
}

resource "local_file" "inventory" {
  content = templatefile(
    "${path.module}/inventory.tftpl",
    {
      "user" : var.vm_user,
      "password": var.vm_password,
      "private_key_path" : var.private_key_path,
      "servers" : proxmox_vm_qemu.srv,
    }
  )
  filename = "${path.module}/inventory"
}

resource "local_file" "sshconf" {
  content = templatefile("${path.module}/sshconf.tftpl",
    {
      "user" : var.vm_user,
      "private_key_path" : pathexpand(var.private_key_path),
      "server" = proxmox_vm_qemu.srv[0],
    }
  )
  filename = "sshconf"
}
