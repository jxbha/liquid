variable "url" {
  description = "Proxmox URL"
  type        = string
}

variable "node" {
  description = "Promox Node"
  type        = string
}
variable "proxmox_api_id" {
  description = "Username for defined Proxmox Token"
  type        = string
}

variable "proxmox_api_secret" {
  description = "Password for defined Proxmox Token"
  type        = string
}

variable "target_vm_id" {
  description = "Proxmox Virtual Machine ID"
  type        = string
  default     = 120
}

variable "source_vm_id" {
  description = "Proxmox Virtual Machine ID"
  type        = string
  default     = 9999
}
