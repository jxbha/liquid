#!/bin/bash

# Bootstraps the cluster registry during a kube port-forward
#
# Currently assumes everything has been tagged for localhost on the workstation.
# Might clean that up later.

set -e

KPORT="localhost:5000"
images=(
    "helper:4"
    "mana:latest"
    "helper:4"
    "postgres:17"
    "kubectl:1.33"
    "golang:1.23"
    "alpine:3.20"
    "buildkit:v0.21.1-rootless"
)

fwd(){
    kubectl port-forward svc/registry 5000:5000 &
    PID=$!
    echo "Starting process: $PID"
}

clean(){
    echo "Killing process: $PID"
    kill $PID
}
trap clean EXIT

tag(){
    for image in "${images[@]}"; do
        podman tag localhost/$image $KPORT/$image
    done
}

push(){
    for image in "${images[@]}"; do
        podman push --tls-verify=false $KPORT/$image
    done
}

main(){
    fwd
    tag
    push
}

main
