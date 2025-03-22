resource "proxmox_virtual_environment_vm" "kube-worker" {
  # Proxmox may not support `count`.
  for_each = {
    "kube-worker-01" = {
      ip    = "192.168.3.21/22" # just hardcoding for simplified testing
      name  = "kube-worker-01"
      vm_id = var.target_vm_id + 1
    }

    "kube-worker-02" = {
      ip    = "192.168.3.22/22" # ""
      name  = "kube-worker-02"
      vm_id = var.target_vm_id + 2
    }
  }

  name      = each.value.name
  node_name = var.node
  vm_id     = each.value.vm_id

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

  lifecycle {
    ignore_changes = [
      initialization[0].ip_config[0].ipv4[0].address,
      initialization[0].ip_config[0].ipv4[0].gateway,
    ]
  }

  network_device {
    bridge = "vmbr0"
    disconnected = false
    enabled = true
    firewall = true
    model = "virtio"
  }

  initialization {
    dns {
      servers = ["192.168.3.15", "1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = "192.168.0.1"
      }
    }
  }
}

resource "proxmox_virtual_environment_vm" "kube-controller" {
  name      = "kube-controller-01"
  node_name = var.node
  vm_id     = var.target_vm_id

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

  lifecycle {
    ignore_changes = [
      initialization[0].ip_config[0].ipv4[0].address,
      initialization[0].ip_config[0].ipv4[0].gateway,
    ]
  }

  network_device {
    bridge = "vmbr0"
    disconnected = false
    enabled = true
    firewall = true
    model = "virtio"
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

module "ansible" {
  source = "../ansible"

  workers = {
    for k, v in proxmox_virtual_environment_vm.kube-worker : k => join("", v.ipv4_addresses[1])
  }

  controllers = {
    "kube-controller-01" = join("", proxmox_virtual_environment_vm.kube-controller.ipv4_addresses[1])
  }

  depends_on = [
    proxmox_virtual_environment_vm.kube-worker,
    proxmox_virtual_environment_vm.kube-controller
  ]
}

resource "null_resource" "ansible" {
  depends_on = [module.ansible]
  provisioner "local-exec" {
    when    = create
    command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i ../ansible/inventory.ini ../ansible/site.yaml"
  }
}
