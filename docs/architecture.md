# Architecture Overview

## Overview

**liquid** is a self-hosted infrastructure platform designed to automate the provisioning and configuration of a Kubernetes-based private environment. It leverages open-source tooling to manage VMs, images, packages, and workloads in an (eventually) fully reproducible way.

---


## Hardware

- Server: Lenovo ThinkCentre M910Q
- CPU: 8 x Intel(R) Core(TM) i7-6700T CPU @ 2.80GHz (1 Socket)
- RAM: 32GB
- Storage: Kingston 1TB SSD

## Stack Breakdown

| Layer            | Tool             | Purpose                                                                        |
|------------------|------------------|--------------------------------------------------------------------------------|
| Virtualization   | Proxmox VE       | Hypervisor platform to host VMs                                                |
| Image Management | Packer           | Builds golden Ubuntu cloud images with cloud-init and Proxmox templates        |
| Provisioning     | Terraform / Tofu | Uses a Proxmox Provider, Creates VMs, sets up networks, allocates resources    |
| Configuration    | Ansible          | Post-provision VM setup and service configuration                              |
| Orchestration    | kubeadm          | Bootstraps and manages the Kubernetes cluster                                  |

## Dependencies

* **kubernetes (1.32.2)**:
* **OpenTofu (1.9)**:
* **ansible (2.16)**:

        ansible-galaxy collection install community.general
        ansible-galaxy collection install ansible.posix


## Repository Layout

```bash
liquid/
├── app/          # Target application (little DIY "production" app)
├── bin/          # Helper scripts (image building, secret management, etc.)
├── infra/        # Infrastructure and platform layer: packer config, terraform, ansible, and kubernetes manifests
├── docs/         # Documentation and architecture notes
├── .env.template # Environment file template to be copied and filled; a lot of this will be replaced with secrets management
└── README.md     # Project entrypoint
```
