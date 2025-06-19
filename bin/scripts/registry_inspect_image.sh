#!/usr/bin/env bash

IMAGE=$1
if [[ -z "$IMAGE" ]]; then
  echo "Please provide an image"
  exit
fi

kubectl exec -it pods/helper -- curl -sf \
  https://registry.dev-tools.svc.cluster.local:5000/v2/$IMAGE/tags/list  2> /dev/null || \
  { echo "[ERROR] $IMAGE not found. Please check spelling and current images"; exit 1; }

