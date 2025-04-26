#!/bin/bash

cd $ROOT
display_help(){
    echo "Usage: $0 <command> [options]"
    echo "Available options:"
    echo "  help             You are here."
    echo "  minikube         Runs the minikube bootstrapper. Minikube must be running (for now.)"
    echo "  k3d              Runs the k3d bootstrapper. This may be deprecated in the future."
    echo "  decrypt          Decrypts all secrets in the project."
    echo "  encrypt          Encrypts all secrets in the project."
    echo "  certificates     Create necessary self-signed certificates."
    echo "  registry         Prepare registry with images from podman."
}

minikube_setup(){
    ./bin/minikube/minikube_setup.sh
}

k3d_init(){
    shift
    ./bin/k3d/k3d_init.sh "$@"
}

cryptid(){
    ./bin/security/cryptid.sh
}

dcryptid(){
    ./bin/security/dcryptid.sh
}

certificates(){
    shift
    ./bin/security/selfsign.sh "$@"
}

registry() {
    shift
    ./bin/scripts/registry_init.sh "$@"
}

main() {
    case "$1" in
        "help")
            display_help
            ;;
        "minikube")
            minikube_setup
            ;;
        "k3d")
            k3d_init
            ;;
        "encrypt")
            cryptid
            ;;
        "decrypt")
            dcryptid
            ;;
        "certificates")
            certificates
            ;;
        "registry")
            registry
            ;;
        *)
            display_help
            ;;
    esac
}

main "$1"
