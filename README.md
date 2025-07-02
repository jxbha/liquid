liquid
======

A Homelab, hopefully eventually entirely encapsulated in code, using modern practices.

see [architecture](./docs/architecture.md) for more information.

## Current Status / Roadmap

- [x] Basic repository structure
- [x] Hypervisor setup (Proxmox)
- [x] Infrastructure as Code (Terraform/OpenTofu)
- [x] Configuration as Code (Ansible)
- [x] VM Image Management (Packer)
- [x] CI/CD Pipeline (in progress with Gitea + Tekton)
- [ ] Kubernetes orchestration (In Progress with kubeadm + ArgoCD)
- [ ] Monitoring and observability
- [ ] Secret management
- [ ] Distributed storage
- [ ] Backup and recovery
- [ ] Complete documentation

## Quick Start

This is in-progress. Currently, Packer and Tofu must be run separately. Tofu will run all Ansible code, generating the inventory file and bootstrapping the cluster with one controller and two workers. Eventually this will be extensible from Tofu - ansible is already extensible and will configure as many systems as are dynamically generated in the inventory by Tofu.

Coming soon.

## Tech Stack

- **Hypervisor**: [Proxmox](https://proxmox.com/en/)
- **Operating System**: [Ubuntu 24.04 LTS (Noble)](https://releases.ubuntu.com/noble/)
- **VM Management**: [Packer](https://www.packer.io/) w/ [cloud-init](https://cloud-init.io/)
- **Infrastructure**: [Terraform](https://www.terraform.io/) / [OpenTofu](https://opentofu.org/)
- **Configuration**: [Ansible](https://docs.ansible.com/)
- **Container Orchestration**: Kubernetes ([kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/))
- **CI/CD**: Gitea + Tekton (in progress)
- **GitOps**: ArgoCD (soon)

---

## Repository Layout

```bash
liquid/
├── app/          # Target application
├── bin/          # Helper scripts
├── infra/        # Infrastructure code
├── docs/         # Documentation and architecture notes
└── README.md     # You are here
```
