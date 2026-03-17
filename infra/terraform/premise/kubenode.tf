resource "proxmox_virtual_environment_vm" "kube-worker" {
  depends_on = [proxmox_virtual_environment_vm.dns]

for_each = var.kube_workers
  name      = each.key
  node_name = var.node
  vm_id =   var.target_vm_base_id + each.value.vm_id_offset

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
    bridge       = "vmbr0"
    disconnected = false
    #enabled = true
    firewall = true
    model    = "virtio"
  }

  initialization {
    dns {
      servers = [var.dns_ip, "1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = "${each.value.ip}/22"
        gateway = var.gateway_ip
      }
    }
  }
}

resource "proxmox_virtual_environment_vm" "kube-controller" {
  depends_on = [proxmox_virtual_environment_vm.dns]
  for_each = var.kube_controllers
    name      = each.key
    node_name = var.node
    vm_id =   var.target_vm_base_id + each.value.vm_id_offset

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
    bridge       = "vmbr0"
    disconnected = false
    firewall     = true
    model        = "virtio"
  }

  initialization {
    dns {
      servers = [var.dns_ip, "1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = "${each.value.ip}/22"
        gateway = var.gateway_ip
      }
    }
  }
}

module "ansible" {
  source = "../../ansible"

  workers = {
    for k, v in proxmox_virtual_environment_vm.kube-worker : k => join("", v.ipv4_addresses[1])
  }

  controllers = {
    for k, v in proxmox_virtual_environment_vm.kube-controller : k => join("", v.ipv4_addresses[1])
  }


  dns_ip = var.dns_ip

  depends_on = [
    proxmox_virtual_environment_vm.kube-worker,
    proxmox_virtual_environment_vm.kube-controller
  ]
}

resource "null_resource" "ansible" {
  depends_on = [module.ansible]
  provisioner "local-exec" {
    when    = create
    command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i ../../ansible/inventory.ini ../../ansible/site.yaml"
  }
}
