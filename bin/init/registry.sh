#!/usr/bin/env bash

# Bootstraps the cluster registry during a kube port-forward
#
# Currently assumes everything has been tagged for localhost on the workstation.
# Might clean that up later.

set -e

KPORT="localhost:5000"
images="$ROOT/infra/kube/containers/versions.txt"

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
    while read -r record; do
        image=$(basename $record)
        podman tag localhost/$image $KPORT/$image
    done < $images
}

push(){
    while read -r record; do
        image=$(basename $record)
        podman push --tls-verify=false $KPORT/$image
    done < $images
}

main(){
    fwd
    tag
    push
}

main
