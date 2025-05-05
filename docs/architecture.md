# Architecture Overview

## Overview

**liquid** is a self-hosted infrastructure platform designed to automate the provisioning and configuration of a Kubernetes-based private environment. It leverages open-source tooling to manage VMs, images, packages, and workloads in a fully reproducible way.

---

## Stack Breakdown

| Layer            | Tool             | Purpose                                                                        |
|------------------|------------------|--------------------------------------------------------------------------------|
| Virtualization   | Proxmox VE       | Hypervisor platform to host VMs                                                |
| Image Management | Packer           | Builds golden Ubuntu cloud images with cloud-init and Proxmox templates        |
| Provisioning     | Terraform / Tofu | Uses a Proxmox Provider, Creates VMs, sets up networks, allocates resources    |
| Configuration    | Ansible          | Post-provision VM setup and service configuration                              |
| Orchestration    | kubeadm          | Bootstraps and manages the Kubernetes cluster                                  |

---

## Repository Layout

```bash
liquid/
├── app/          # Target application (DIY sockshop for CI/CD)
├── bin/          # Helper scripts (image building, secret management, etc.)
├── infra/        # Infrastructure and platform layer: packer config, terraform, ansible, and kubernetes manifests
├── docs/         # Documentation and architecture notes
├── .env.template # Environment file template to be copied and filled; a lot of this will be replaced with secrets management
└── README.md     # Project entrypoint
