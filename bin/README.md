# bin/ 

## Overview
Meant for environment scripts and utilities.

This sort of uses a **dispatch pattern**, where we create our subshell, which adds dispatch.sh to PATH. We then use dispatch.sh to call the rest of our scripts as necessary. I usually alias it to `ds` because it's WASD-reachable and tab auto-complete suggests DISPLAY on Linux.

As an example, from the project root...

1. Create the project subshell:

        ./bin/envsetup

2. Run dispatch.sh with various commands

        Usage: dispatch.sh <command> [options]

        Available options:
            help               You are here.
            bootstrap          Bootstrap various environments.
            decrypt            Decrypts all secrets in the project.
            encrypt            Encrypts all secrets in the project.
            certs              Create necessary self-signed certificates.
            containers         Pull all necessary container images
            init               Initialize various assets.
            images             Check current images in cluster registry.
            image              Check tags for provided image.


Arguments in subscripts are included in dispatch.sh using bash's builtin `shift`.

    bin
    ├── bootstrap
    │   ├── dev.sh                    # bootstraps kubeadm on libvirt VMs
    │   ├── k3d.sh                    # bootstraps k3d
    │   ├── minikube.sh               # bootstraps minikube environment
    │   └── README.md
    ├── dispatch.sh                   # entrypoint to all utilities
    ├── envsetup                      # a workspace-setter, akin to "venv" for the project. always initialize this first to utilize scripts and utilities
    ├── init
    │   ├── assets.sh                 # handles external kubernetes assets
    │   ├── containers.sh             # pulls external containers for cluster registry
    │   └── registry.sh               # pushes external containers to cluster registry
    ├── Makefile
    ├── README.md
    ├── scripts
    │   ├── registry_inspect_image.sh # check all tags of provided image from cluster registry
    │   ├── registry_list_images.sh   # check all images from cluster registry
    │   └── reset.sh                  # deprecated; was to prep hostPath volumes
    └── security
        ├── cryptid.sh                # encrypt all 'secret.yaml' files in the project
        ├── dcryptid.sh               # decrypt all 'secret.yaml' files in the project
        └── selfsign.sh               # create namespaced certs: internal certificate, external certificate, and optionally the root CA

Down the line, `help` flags will be added for each utility
