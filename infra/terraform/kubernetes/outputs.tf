output "kube_workers" {
  value = {
    for k, v in proxmox_virtual_environment_vm.kube-worker : k => split("/", v.initialization[0].ip_config[0].ipv4[0].address)[0]
  }
}

output "kube_controllers" {
  value = {
    for k, v in proxmox_virtual_environment_vm.kube-controller : k => split("/", v.initialization[0].ip_config[0].ipv4[0].address)[0]
  }
}
