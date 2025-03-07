packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_api_secret" {
  description = "Password for defined Proxmox Token"
  type        = string
}

variable "proxmox_api_id" {
  description = "Username for defined Proxmox Token"
  type        = string
}

variable "node" {
  description = "Promox Node"
  type        = string
}

variable "url" {
  description = "Proxmox URL"
  type        = string
}

variable "vmid" {
  description = "Desired template ID"
  type        = number
  default     = 9999
}


source "proxmox-iso" "ubuntu" {
  boot_iso {
    type         = "scsi"
    iso_file     = "local:iso/ubuntu-24.04.2-live-server-amd64.iso"
    iso_checksum = "d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d"
    unmount      = true
  }
  node                     = "${var.node}"
  insecure_skip_tls_verify = true
  cores                    = 1
  memory                   = 2048
  disks {
    disk_size    = "32G"
    format       = "raw"
    type         = "virtio"
    storage_pool = "local-lvm"
  }
  network_adapters {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = true
  }
  scsi_controller         = "virtio-scsi-pci"
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
    "<f10><wait>"
  ]
  http_directory       = "./http"
  boot                 = "c" # this might be the default.
  boot_wait            = "5s"
  onboot               = true
  task_timeout         = "2m"
  vm_id                = "${var.vmid}"
  os                   = "l26"
  token                = "${var.proxmox_api_secret}"
  proxmox_url          = "https://${var.url}:8006/api2/json"
  ssh_username         = "gh0st"
  ssh_private_key_file = "~/.ssh/liquid/id_ed25519"
  ssh_timeout          = "10m"
  template_description = "Packer-generated ubuntu image"
  template_name        = "ubuntu-scaffold"
  username             = "${var.proxmox_api_id}"
}

build {
  name    = "ubuntu-scaffold"
  sources = ["source.proxmox-iso.ubuntu"]
  # provisioner "shell-local" {
  #   inline = [
  #     # this may not be needed; see [here](https://github.com/hashicorp/packer-plugin-proxmox/pull/93)
  # "curl -k -X DELETE 'https://${var.url}:8006/api2/json/nodes/${var.node}/qemu/${var.vmid}' -H 'Authorization: PVEAPIToken=${var.proxmox_api_id}=${var.proxmox_api_secret}' || true"
  #   ]
  # }
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/*-installer-config.yaml",
      "sudo sync",
    ]
  }

  provisioner "file" {
    source      = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  provisioner "shell" {
    inline = [
      "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg",
      "sudo swapoff -a",
      "sudo sed -i '/\\/swap.img/ s/^/#/' /etc/fstab", # may not actually be necessary here
      "sudo sed -iE 's/^#DNS=$/DNS=192.168.3.15 1.1.1.1/' /etc/systemd/resolved.conf",
      "sudo sed -iE 's/^#FallbackDNS=$/FallbackDNS=8.8.8.8/' /etc/systemd/resolved.conf",
      "sudo sed -iE 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=10/' /etc/default/grub",
      "sudo systemctl restart systemd-resolved",
    ]
  }
}
