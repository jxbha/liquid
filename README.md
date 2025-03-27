liquid
======

A Homelab, hopefully eventually entirely encapsulated in code.


Environment
---
- **Hypervisor**: [Proxmox](https://proxmox.com/en/)
- **Virtual Machines**: [Ubuntu 24.04 LTS (Noble)](https://releases.ubuntu.com/noble/)
- **Kubernetes Distribution**: [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
- **Golden Images**: [Packer](https://www.packer.io/) w/ [cloud-init](https://cloud-init.io/)
- **IaC**: [Terraform](https://www.terraform.io/) ([OpenTofu](https://opentofu.org/))
- **CaC**: [Ansible](https://docs.ansible.com/)

Dependencies
---
* **ansible**:

        ansible-galaxy collection install community.general
        ansible-galaxy collection install ansible.posix

