#!/usr/bin/env bash

# NOTE: Deprecated; now handled via a Kubernetes job: $ROOT/infra/kube/utility/jobs/upstream/

set -e
CONTAINERS="$ROOT/infra/kube/containers/versions.txt"

pull() {
    while read -r record; do
        podman pull "$record"
    done < "$CONTAINERS"
}

tag() {
    while read -r record; do
        image=$(basename $record)
        podman tag "$record" localhost/"$image"
    done < "$CONTAINERS"
}

main() {
    echo "WAIT! deprecated - see liquid/infra/kube/utility/jobs/upstream/bootstrap-registry.yaml"
    exit 1
}

main
