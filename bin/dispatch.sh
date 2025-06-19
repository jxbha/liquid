#!/usr/bin/env bash

set -e

cd $ROOT
BIN=$ROOT/bin

usage(){
    cat <<EOF
Usage: $0 <command> [options]

Available options:
    help               You are here.
    bootstrap          Bootstrap various environments.
    decrypt            Decrypts all secrets in the project.
    encrypt            Encrypts all secrets in the project.
    certs              Create necessary self-signed certificates.
    registry           Prepare registry with images from podman.
    containers         Pull all necessary container images
    images             Check current images in cluster registry.
    image              Check tags for provided image.
    assets             Downloads all third-party resources for Kubernetes.
    resetvol           Resets directories for persistent volumes. Hacky but temporary.
EOF
}

main(){
    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    local command="$1"
    local subcommand="$2"
    shift

    case "$command" in
        help)
            usage
            ;;
        bootstrap)
            case "$subcommand" in
                minikube)
                    $BIN/bootstrap/minikube.sh "$@"
                    ;;
                k3d)
                    $BIN/k3d/k3d_init.sh "$@"
                    ;;
                dev)
                    $BIN/bootstrap/dev.sh "$@"
                    ;;
                *)
                    echo "Usage: $0 bootstrap { minikube|k3d|dev }"
                    ;;
            esac
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
            $BIN/init/registry.sh "$@"
            ;;
        containers)
            $BIN/init/containers.sh "$@"
            ;;
        assets)
            $BIN/init/assets.sh "$@"
            ;;
        images)
            $BIN/scripts/registry_list_images.sh "$@"
            ;;
        image)
            $BIN/scripts/registry_inspect_image.sh "$@"
            ;;
        resetvol)
            $BIN/scripts/reset.sh
            ;;
        *)
            echo -e "[ERROR] Unknown command: $command\n"
            usage
            ;;
    esac
}

main "$@"
