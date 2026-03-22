#!/bin/bash
# helm repo add openbao-secrets-operator https://github.com/openbao/openbao-secrets-operator
# helm repo add external-secrets https://charts.external-secrets.io

if [ -z $ROOT ]; then
    echo "[ERROR    root directory unset; check workspace"
    exit 1
fi

helm uninstall -n vault openbao
kubectl delete -n vault job/init-bao job/bootstrap-bao job/bootstrap-pki secret/bao-root-token secret/bao-unseal-key pvc/data-openbao-0
kubectl apply -f "$ROOT"/infra/kube/platform/bao/rbac.yaml
kubectl apply -f "$ROOT"/infra/kube/platform/ssl/rbac.yaml
helm install openbao "$ROOT"/infra/kube/platform/bao/ \
  -n vault \
  --create-namespace \
  -f "$ROOT"/infra/kube/platform/bao/values.yaml
kubectl apply -f "$ROOT"/infra/kube/bootstrap/bao/init-bao.yaml
kubectl wait --for=condition=complete job/init-bao -n vault --timeout=180s
kubectl apply -f "$ROOT"/infra/kube/ops/cronjobs/bao/unseal.yaml
timeout 120 bash -c '
    until kubectl exec -n vault openbao-0 -- bao status -format=json 2>/dev/null | grep -q "sealed.*false"; do
      echo "[INFO]    waiting on unseal...";
      sleep 5;
    done
'
kubectl apply -f "$ROOT"/infra/kube/bootstrap/bao/bootstrap-bao-pki.yaml
kubectl apply -f "$ROOT"/infra/kube/bootstrap/bao/bootstrap-bao-kv.yaml
kubectl wait --for=condition=complete job/bootstrap-pki job/bootstrap-bao -n vault --timeout=180s
kubectl apply -f "$ROOT"/infra/kube/platform/bao/secret-store.yaml
dispatch.sh bootstrap secrets
