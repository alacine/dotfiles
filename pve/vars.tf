variable "pm_host" {
  description = "proxmox host"
  type        = string
  default     = "192.168.31.169"
}

variable "pm_admin" {
  description = "proxmox user"
  type        = string
  default     = "root"
}

variable "pm_api_url" {
  description = "proxmox api url"
  type        = string
  default     = "https://192.168.31.169:8006/api2/json"
  sensitive   = false
}

variable "pm_user" {
  description = "proxmox user"
  type        = string
  sensitive   = false
}

variable "pm_api_token_id" {
  description = "proxmox api token id"
  type        = string
  sensitive   = true
}

variable "pm_api_token_secret" {
  description = "proxmox api token id"
  type        = string
  sensitive   = true
}

variable "vm_user" {
  description = "user name for vm"
  type        = string
  default     = "ubuntu"
  sensitive   = false
}

variable "vm_password" {
  description = "user password for vm_user"
  type        = string
  sensitive   = true
}

variable "vm_sshkey_file" {
  description = "ssh key for vm_user"
  type        = string
  sensitive   = true
  default     = "~/.ssh/id_rsa.pub"
}
