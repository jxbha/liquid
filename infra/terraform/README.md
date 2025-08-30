# infra/terraform 

## Overview

This uses one of the two current Proxmox providers `bpg/proxmox`. We use a pre-baked custom image built using [Packer](https://www.packer.io/) as a base from which to deploy a set of kubernetes nodes. Currently we have far too much of this hardcoded, with worker nodes requiring an `ip`, `name`, and `vm_id` to be defined each. The rest is defined globally for all workers. Similarly, we have the control node organized in the same way, so that in the case that we want multiple controllers, we can simply wrap these fields in a loop and iterate accordingly.

This kicks off an ansible module for the OS-level configuration of the Kubernetes cluster. The inventory is dynamically generated from the terraform/tofu.

## Layout

    infra/terraform
    ├── http
    │   └── user-data     # deprecated, artifact; data to be passed via cloud-init, now done post-provision in ansible
    ├── kubenode.tf       # the `main.yaml`; currently contains too much structure, including all node configurations with the necessary ansible module
    ├── modules
    ├── outputs.tf        # Returns nothing; eventually this will provide IPs that we will integrate into our DNS generation
    ├── provider.tf       # provider 
    ├── README.md         # You are here
    ├── terraform.tfvars
    └── variables.tf      # defaults and variables for customizing the deployment; to grow drastically.

