terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.73.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.url}:8006/"
  api_token = "${var.proxmox_api_id}=${var.proxmox_api_secret}"
  insecure  = true
  ssh {
    agent       = true
    username    = "root"
    private_key = file("~/.ssh/liquid/id_ed25519")
  }
}
