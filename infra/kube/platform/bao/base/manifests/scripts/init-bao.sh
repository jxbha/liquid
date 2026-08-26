#!/bin/sh

apk add --no-cache jq kubectl

clean(){
rm -f bao-init-output.txt secret.tmp
}
trap clean EXIT

# check if bao is initialized
READY=$(bao status -format=json 2>/dev/null | jq -r .initialized || echo "unknown")
echo "SERVER STATUS: " $READY

# if not, run `bao operator init` - collect output into secrets
if [ "$READY" = "false" ]; then
bao operator init -format=json > bao-init-output.txt
i=1
for key in $(cat bao-init-output.txt | jq -r '.unseal_keys_b64 | .[]'); do
    echo "[INFO]    retrieving unseal key $i"
    bao operator unseal $key
    echo BAO_UNSEAL_KEY_$i=$key >> secret.tmp
    i=$((i+1))
done
    echo "[INFO]    creating secrets"
export ROOT_TOKEN=$(cat bao-init-output.txt | jq -r '.root_token')
kubectl create secret generic -n vault --dry-run=client -o yaml --from-env-file secret.tmp bao-unseal-key | kubectl apply -f -
kubectl create secret generic -n vault --dry-run=client -o yaml --from-literal=token=$ROOT_TOKEN bao-root-token | kubectl apply -f -
elif [ "$READY" = "true" ]; then
echo "[INFO]    bao already initialized; exiting"
exit 0
else
echo "[ERROR]    cannot connect to bao"
exit 1
fi
export ROOT_TOKEN=$(cat bao-init-output.txt | jq -r '.root_token')
bao login $ROOT_TOKEN
bao auth enable kubernetes
bao write auth/kubernetes/config \
    kubernetes_host=https://kubernetes.default.svc.cluster.local:443
bao policy write bootstrap /opt/bootstrap/bootstrap-policy.hcl
bao write auth/kubernetes/role/bootstrap-bao \
bound_service_account_names=bootstrap-bao \
bound_service_account_namespaces=vault \
policies=bootstrap
