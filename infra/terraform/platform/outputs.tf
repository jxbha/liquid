output "dns_ip" {
  value = split("/", proxmox_virtual_environment_vm.dns.initialization[0].ip_config[0].ipv4[0].address)[0]
}

output "repo_ip" {
  value = split("/", proxmox_virtual_environment_vm.repo.initialization[0].ip_config[0].ipv4[0].address)[0]
}

output "proxy_ip" {
  value = split("/", proxmox_virtual_environment_vm.proxy.initialization[0].ip_config[0].ipv4[0].address)[0]
}

output "test_ip" {
  value = split("/", proxmox_virtual_environment_vm.test.initialization[0].ip_config[0].ipv4[0].address)[0]
}
