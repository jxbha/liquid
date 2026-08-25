resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/platform.tftpl",
    {
      user        = var.user
      ssh_key     = var.ssh_key
      dns_ip      = var.dns_ip
      repo_ip     = var.repo_ip
      proxy_ip    = var.proxy_ip
    }
  )
  filename = "../../ansible/platform.ini"
}
