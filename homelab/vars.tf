variable "pm_endpoint" {
  description = "proxmox api endpoint (e.g. https://host:8006/)"
  type        = string
  default     = "https://192.168.88.100:8006/"
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

variable "vm_template_id" {
  description = "proxmox VM template ID to clone from"
  type        = number
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

variable "public_key_path" {
  description = "public key for vm_user"
  type        = string
  sensitive   = true
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "private key for vm_user"
  type        = string
  sensitive   = true
  default     = "~/.ssh/id_rsa"
}
