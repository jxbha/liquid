#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
ROOT_DIR=$(cd $SCRIPT_DIR/../.. && pwd)
VENDOR_DIR="${ROOT_DIR}/infra/kube/vendor"
VERSIONS_FILE="${VENDOR_DIR}/versions.txt"

while IFS='=' read -r name version_url; do
 version=$(echo $version_url | cut -d',' -f1)
 url=$(echo $version_url | cut -d',' -f2)
 
 # Check if manifest exists
 if [ ! -f "${VENDOR_DIR}/$name-$version.yaml" ]; then
#    echo "Downloading $name $version..."
   curl -sSL "$url" -o "${VENDOR_DIR}/$name-$version.yaml"
 fi
done < "$VERSIONS_FILE"
