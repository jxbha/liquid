#!/bin/sh
#build-kubetool.sh

. /scripts/common.sh


image="kubetools:latest"
base_image="alpine:3.20"
packages="ca-certificates jq curl"
extra_run=$(cat <<EOF
curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl && \
chmod +x kubectl && \
mv kubectl /usr/local/bin
EOF
)
build_image "$image" "$base_image" "$packages" "$extra_run"
