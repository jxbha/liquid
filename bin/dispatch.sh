#!/bin/bash

set -e

cd $ROOT
BIN=$ROOT/bin

usage(){
    cat <<EOF
Usage: $0 <command> [options]

Available options:
    help             You are here."
    minikube         Runs the minikube bootstrapper. Minikube must be running (for now.)
    k3d              Runs the k3d bootstrapper. This may be deprecated in the future.
    decrypt          Decrypts all secrets in the project.
    encrypt          Encrypts all secrets in the project.
    certs            Create necessary self-signed certificates.
    registry         Prepare registry with images from podman.
    images           Check current images in cluster registry.
    image            Check tags for provided image.
EOF
}

main(){
    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    local command="$1"
    shift

    case "$command" in
        help)
            usage
            ;;
        minikube)
            $BIN/minikube/minikube_setup.sh "$@"
            ;;
        k3d)
            $BIN/k3d/k3d_init.sh "$@"
            ;;
        encrypt)
            $BIN/security/cryptid.sh "$@"
            ;;
        decrypt)
            $BIN/security/dcryptid.sh "$@"
            ;;
        certs)
            $BIN/security/selfsign.sh "$@"
            ;;
        registry)
            $BIN/scripts/registry_init.sh "$@"
            ;;
        images)
            $BIN/scripts/registry_list_images.sh "$@"
            ;;
        image)
            $BIN/scripts/registry_inspect_image.sh "$@"
            ;;
        *)
            echo -e "[ERROR] Unknown command: $command\n"
            usage
            ;;
    esac
}

main "$@"
