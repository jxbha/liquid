variable "ssh_key" {
    type = string
    default = "~/.ssh/liquid/id_ed25519"
}
variable "user" {
    type = string
    default = "gh0st"
}

variable "workers" {
  type = map(string)
}

variable "controllers" {
  type = map(string)
}

