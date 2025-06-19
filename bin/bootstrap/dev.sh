#!/bin/env bash
kubectl apply -k "$ROOT"/infra/kube/dev-tools/registry
dispatch.sh registry
kubectl apply -k "$ROOT"/infra/kube/overlays/local
