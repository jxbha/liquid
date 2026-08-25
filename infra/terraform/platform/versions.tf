terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.98.1"
    }
  }

  # backend s3 {
  #   bucket = var.remote_state_bucket
  #   key    = "terraform.tfstate"
  #   region = var.aws_region
  # }
}
