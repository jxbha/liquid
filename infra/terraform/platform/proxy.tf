resource "proxmox_virtual_environment_vm" "proxy" {

  name        = "proxy"
  description = "Reverse proxy used by Proxmox host (Cathedral), kubernetes environment (liquid), and relevant workstations"
  tags        = ["terraform", "platform", "proxy"]
  vm_id       = 9003
  node_name   = var.node

  agent {
    enabled = true
  }

  clone {
    vm_id = var.source_vm_id
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  lifecycle {
    ignore_changes = [
      initialization[0].ip_config[0].ipv4[0].address,
      initialization[0].ip_config[0].ipv4[0].gateway,
    ]
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    firewall     = true
    model        = "virtio"
  }


  initialization {
    dns {
      servers = ["${var.dns_ip}", "1.1.1.1", "8.8.8.8"]
    }
    ip_config {
      ipv4 {
        address = "${var.proxy_ip}/22"
        gateway = var.gateway_ip
      }
    }
  }
}
