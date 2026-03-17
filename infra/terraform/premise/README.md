# infra/terraform 

## Overview

This uses one of the two current Proxmox providers `bpg/proxmox`. We use a pre-baked custom image built using [Packer](https://www.packer.io/) as a base from which to deploy a set of kubernetes nodes. Currently we have some of this hardcoded in tfvars, with worker nodes each requiring an `ip` and `vm_id` offset to be defined. The rest is defined globally for all workers. Similarly, we have the control node organized in the same way, so that in the case that we want multiple controllers, we can add more fields in the map and iterate.

This kicks off an ansible module for the OS-level configuration of the Kubernetes cluster. The inventory is dynamically generated from the terraform/tofu.

## Layout

    infra/terraform
    ├── kubenode.tf       # The `main.yaml`; currently contains too much structure, including all node configurations with the necessary ansible module
    ├── dns.tf            # DNS server deployment with evolving /etc/hosts and specific systemd-resolved config
    ├── modules
    ├── outputs.tf        # Returns nothing; eventually this will provide IPs that we will integrate into our DNS generation
    ├── provider.tf       # Provider 
    ├── README.md         # You are here
    ├── terraform.tfvars  # You will see a .template version of this - rename it to this and populate
    └── variables.tf      # Defaults and variables for customizing the deployment
