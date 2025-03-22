liquid
======

A Homelab, hopefully eventually entirely encapsulated in code.


Environment
---
- **Hypervisor**: Proxmox
- **Virtual Machines**: Ubuntu 24.04 LTS (Noble)
- **Kubernetes Distribution**: kubeadm
- **Golden Images**: Packer w/ cloud-init
- **IaC**: Terraform (OpenTofu)
- **CaC**: Ansible

Dependencies
---
* **ansible**: community.general

        ansible-galaxy collection install community.general
        ansible-galaxy collection install ansible.posix

