resource "proxmox_virtual_environment_vm" "kube-worker-01" {
  name      = "kube-worker-01"
  node_name = var.node
  vm_id = var.target_vm_id

  clone {
    vm_id = var.source_vm_id
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  initialization {
    dns {
      servers = ["192.168.3.15", "1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = "192.168.3.20/22"
        gateway = "192.168.0.1"
      }
    }
  }
}

output "kube-worker-01_ipv4_address" {
  value = proxmox_virtual_environment_vm.kube-worker-01.ipv4_addresses[1]
}

output "kube-worker-01_id" {
  value = proxmox_virtual_environment_vm.kube-worker-01.vm_id
}
