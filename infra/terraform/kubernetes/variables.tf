variable "url" {
  description = "Proxmox URL"
  type        = string
}

variable "node" {
  description = "Proxmox Node"
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

variable "ssh_key" {
  description = "SSH key file path"
  type        = string
}

variable "source_vm_id" {
  description = "Proxmox Virtual Machine ID"
  type        = number
  default     = 9999
}

variable "dns_ip" {
  description = "IP address of Cathedral DNS node"
  type        = string
}

variable "gateway_ip" {
  description = "IP address of router"
  type        = string
}

variable "target_vm_base_id" {
  description = "Proxmox Virtual Machine ID"
  type        = number
  default     = 120
}

variable "kube_workers" {
  type = map(object({
    ip           = string
    vm_id_offset = number
  }))
}

variable "kube_controllers" {
  type = map(object({
    ip           = string
    vm_id_offset = number
  }))
}

variable "s3_access_key" {
  description = "Access key for S3 backend"
  type = string
}

variable "s3_secret_key" {
  description = "Secret key for S3 backend"
  type = string
}

variable "user" {
  description = "Username for SSH access"
  type        = string
}
