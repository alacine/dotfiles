variable "libvirt_uri" {
  type        = string
  description = "Libvirt connection URI."
  default     = "qemu:///system"
}

variable "pool" {
  type        = string
  description = "Existing libvirt storage pool."
  default     = "default"
}

variable "network" {
  type        = string
  description = "Existing libvirt NAT network."
  default     = "default"
}

variable "image_path" {
  type        = string
  description = "Path to the Packer-built Arch QCOW2, relative to this Terraform directory."
  default     = "output/arch-qemu/arch.qcow2"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Public key for the devbox account."
  default     = "~/.ssh/id_ed25519.pub"
}

variable "vm_name" {
  type        = string
  description = "VM name and cloud-init instance ID."
  default     = "arch-devbox"
}

variable "memory_mib" {
  type        = number
  description = "VM memory in MiB."
  default     = 2048
}

variable "vcpu" {
  type        = number
  description = "Number of virtual CPUs."
  default     = 2
}
