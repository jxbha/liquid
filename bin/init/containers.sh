#!/usr/bin/env bash

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
    pull
    tag
}

main
