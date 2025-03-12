resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/inventory.tftpl",
    {
      workers     = var.workers
      controllers = var.controllers
      user        = var.user
      ssh_key     = var.ssh_key
    }
  )
  filename = "${path.module}/inventory.ini"
}
