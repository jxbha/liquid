#!/bin/bash
CWD="$ROOT"/infra/kube/bao
# helm repo add openbao-secrets-operator https://github.com/openbao/openbao-secrets-operator
# helm repo add external-secrets https://charts.external-secrets.io

#helm install external-secrets \
#   external-secrets/external-secrets 
#    -n vault \
#    --create-namespace \
#    --set installCRDs=false

if [ -z $ROOT ]; then
    echo "[ERROR    root directory unset; check workspace"
    exit 1
fi

helm uninstall openbao
kubectl delete -n vault job/init-bao job/bootstrap-bao job/bootstrap-pki secret/bao-root-token secret/bao-unseal-key pvc/data-openbao-0
helm install openbao "$ROOT"/infra/kube/charts/openbao \
  -n vault \
  -f "$ROOT"/infra/kube/bao/values.yaml
kubectl apply -f "$ROOT"/infra/kube/bootstrap/init-bao.yaml
kubectl wait --for=condition=complete job/init-bao -n vault --timeout=180s
timeout 120 bash -c '
    until kubectl exec -n vault openbao-0 -- bao status -format=json 2>/dev/null | grep -q "\"sealed\": false"; do 
      echo "[INFO]    waiting on unseal..."; 
      sleep 5; 
    done
'
kubectl apply -f "$ROOT"/infra/kube/bootstrap/bootstrap-bao-pki.yaml
kubectl apply -f "$ROOT"/infra/kube/bootstrap/bootstrap-bao-kv.yaml
kubectl wait --for=condition=complete job/bootstrap-pki job/bootstrap-bao -n vault --timeout=180s
kubectl apply -f "$ROOT"/infra/kube/bao/rbac.yaml
kubectl apply -f "$ROOT"/infra/kube/ssl/rbac.yaml
dispatch.sh bootstrap secrets
