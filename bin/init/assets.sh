#!/usr/bin/env bash

vendor_dir="$ROOT/infra/kube/vendor"
versions_file="$vendor_dir/versions.txt"

while IFS='=' read -r name version_url; do
 version=$(echo $version_url | cut -d',' -f1)
 url=$(echo $version_url | cut -d',' -f2)
 category=$(echo $version_url | cut -d',' -f3)
 
 if [ ! -f "${vendor_dir}/${category}/$name-$version.yaml" ]; then
   echo "Downloading $name $version..."
   curl -sSL "$url" -o "${vendor_dir}/${category}/$name-$version.yaml"
 fi
done < "$versions_file"
