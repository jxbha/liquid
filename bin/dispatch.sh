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
    containers         Pull all necessary container images
    init               Initialize various assets.
    images             Check current images in cluster registry.
    image              Check tags for provided image.
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
                    $BIN/bootstrap/k3d.sh "$@"
                    ;;
                dev)
                    $BIN/bootstrap/dev.sh "$@"
                    ;;
                *)
                    echo "Usage: $0 bootstrap { minikube|k3d|dev }"
                    ;;
            esac
            ;;
        init)
            case "$subcommand" in
                assets)
                    $BIN/init/assets.sh "$@"
                    ;;
                registry)
                    $BIN/init/registry.sh "$@"
                    ;;
                containers)
                    $BIN/init/containers.sh "$@"
                    ;;
                *)
                    echo "Usage: $0 init { assets|registry|containers }"
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
