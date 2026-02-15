#!/bin/sh

. /scripts/common.sh


image="ci-golang:latest"
base_image="golang:1.24-alpine3.22"
packages="ca-certificates jq curl"

build_image "$image" "$base_image" "$packages"
