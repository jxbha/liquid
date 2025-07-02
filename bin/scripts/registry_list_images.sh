#!/usr/bin/env bash

# `cat` here helps with terminal rendering
kubectl exec -it pods/helper -- curl -s \
  https://registry.dev-tools.svc.cluster.local:5000/v2/_catalog | \
  jq -r '.repositories[]' | cat
