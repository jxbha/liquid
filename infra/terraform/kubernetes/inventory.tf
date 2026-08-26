resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/kubernetes.tftpl",
    {
      workers     = var.kube_workers
      controllers = var.kube_controllers
      user        = var.user
      ssh_key     = var.ssh_key
      dns_ip      = var.dns_ip
    }
  )
  filename = "../../ansible/platform.ini"
}
