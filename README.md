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
- [x] CI/CD Pipeline (Gitea + Tekton)
- [ ] Kubernetes orchestration (maybe)
- [x] Monitoring and observability
- [x] Secret management
- [ ] Distributed storage
- [ ] Backup and recovery
- [ ] Complete documentation

## Quick Start

This is in-progress. Currently, Packer and Tofu must be run separately. Packer creates images using Tofu will run all Ansible code, generating the inventory file and bootstrapping the cluster with one controller and two workers. 

## Tech Stack

- **Hypervisor**: [Proxmox](https://proxmox.com/en/)
- **Operating System**: [Ubuntu 24.04 LTS (Noble)](https://releases.ubuntu.com/noble/)
- **VM Management**: [Packer](https://www.packer.io/) w/ [cloud-init](https://cloud-init.io/)
- **Infrastructure**: [Terraform](https://www.terraform.io/) / [OpenTofu](https://opentofu.org/)
- **Configuration**: [Ansible](https://docs.ansible.com/)
- **Container Orchestration**: Kubernetes ([kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/))
- **CI/CD**: [Gitea](https://about.gitea.com/products/gitea/) + [Tekton](https://tekton.dev/)

---

## Repository Layout

```bash
liquid/
├── app/          # Target application
├── bin/          # Helper scripts
├── config/       # Currently holds CA cert, SSL stuff
├── infra/        # Infrastructure code
├── docs/         # Documentation and architecture notes
└── README.md     # You are here
```
