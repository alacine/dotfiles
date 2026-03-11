#output "vm_count" {
#description = "count of vm"
#value = length(proxmox_vm_qemu.ubuntu)
#}

#output "vm_list" {
#description = "list all vms"
#value = [proxmox_vm_qemu.ubuntu[0].name, proxmox_vm_qemu.ubuntu[0].ipconfig0]
#}
