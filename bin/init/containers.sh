#!/usr/bin/env bash

CONTAINERS="$ROOT/infra/kube/containers/versions.txt"

build_local_mana() {
    cd $ROOT/app/mana
    podman build -t mana:latest .
}

build_local_helper() {
    cd $ROOT/infra/kube/utility/helper
    podman build -t helper:4 .
}

build_local() {
    build_local_mana
    build_local_helper
}

pull() {
    while read -r record; do
        podman pull "$record" 2> /dev/null || echo "Custom image: $record"
    done < "$CONTAINERS"
}

tag() {
    while read -r record; do
        image=$(basename $record)
        podman tag "$record" localhost/"$image"
    done < "$CONTAINERS"
}

main() {
    build_local
    pull
    tag
}

main
