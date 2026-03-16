terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.98"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pm_endpoint
  api_token = "${var.pm_api_token_id}=${var.pm_api_token_secret}"
  insecure  = true

  ssh {
    agent       = false
    username    = "root"
    private_key = file(pathexpand(var.private_key_path))

    node {
      name    = "pve"
      address = "192.168.88.100"
      port    = 22
    }
  }
}

locals {
  vm_count = 1
  vms = [for i in range(local.vm_count) : {
    name     = "srv-${i + 1}"
    ssh_host = "192.168.88.${i + 101}"
    ip       = "192.168.88.${i + 101}/24"
  }]
}

resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = templatefile(
      "${path.module}/cloud-init/user_data.tftpl",
      {
        name       = var.vm_user
        password   = var.vm_password
        public_key = file(var.public_key_path)
      }
    )
    file_name = "user_data_vm.yml"
  }
}

resource "proxmox_virtual_environment_vm" "srv" {
  count     = local.vm_count
  name      = local.vms[count.index].name
  node_name = "pve"
  on_boot   = true

  clone {
    vm_id = var.vm_template_id
  }

  agent {
    enabled = true
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "local-lvm"
    size         = 200
    interface    = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data.id

    dns {
      servers = ["1.1.1.1", "223.5.5.5"]
    }

    ip_config {
      ipv4 {
        address = local.vms[count.index].ip
        gateway = "192.168.88.1"
      }
    }
  }
}

resource "null_resource" "refresh_ssh_config" {
  depends_on = [proxmox_virtual_environment_vm.srv]

  triggers = {
    ssh_host = local.vms[0].ssh_host
  }

  provisioner "local-exec" {
    command = <<EOF
      ssh-keygen -R ${local.vms[0].ssh_host} || true
      until ssh-keyscan ${local.vms[0].ssh_host} >> ~/.ssh/known_hosts 2>/dev/null; do
        echo "Waiting for SSH on ${local.vms[0].ssh_host}..."
        sleep 5
      done
    EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = "ssh-keygen -R ${self.triggers.ssh_host}"
  }
}

resource "null_resource" "setup_server" {
  depends_on = [null_resource.refresh_ssh_config]

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_CONFIG=${path.module}/ansible/ansible.cfg \
      ansible-playbook \
        --connection=ssh \
        --inventory=${local_file.inventory.filename} \
        ${path.module}/ansible/playbook/server.yml
    EOF
  }
}

resource "local_file" "inventory" {
  content = templatefile(
    "${path.module}/inventory.tftpl",
    {
      user             = var.vm_user
      password         = var.vm_password
      private_key_path = var.private_key_path
      servers          = local.vms
    }
  )
  filename = "${path.module}/inventory"
}

resource "local_file" "sshconf" {
  content = templatefile(
    "${path.module}/sshconf.tftpl",
    {
      user             = var.vm_user
      private_key_path = pathexpand(var.private_key_path)
      server           = local.vms[0]
    }
  )
  filename = "sshconf"
}
