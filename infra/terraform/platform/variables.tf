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

variable "repo_ip" {
  description = "IP address of Cathedral Git Repository"
  type        = string
}

variable "proxy_ip" {
  description = "IP address of Cathedral Proxy Server"
  type        = string
}

variable "test_ip" {
  description = "IP address of Cathedral testbed server"
  type        = string
}

variable "user" {
  description = "Username for SSH access"
  type        = string
}
