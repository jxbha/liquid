# Secrets Management with OpenBao

## Overview
> from: https://developer.hashicorp.com/vault/docs/auth/kubernetes#how-to-work-with-short-lived-kubernetes-tokens

The goal is to set up a ExternalSecretsOperator, in order to retrieve secrets from OpenBao and generate Kubernetes secret resources from those KV pairs.

## Prerequisites
- Kubernetes Cluster in a Ready state
- OpenBao instance in a Ready state
- bao CLI access

## Steps
1a. Enable kubernetes auth
```bash
bao auth enable kubernetes
```

1b. Retrieve Kubernetes CA cert
```bash
kubectl config view --minify --flatten -ojson \
  | jq -r '.clusters[].cluster."certificate-authority-data"' \
  | base64 -d >/tmp/cacrt
```

1c. Write host URL and, if bao is external, CA cert to kubernetes auth
```bash
bao write auth/kubernetes/config \
    kubernetes_host=<kubernetes-api-server-url> \
    kubernetes_ca_cert=@/tmp/cacrt
```

> If OpenBao runs inside the cluster, you can omit `kubernetes_ca_cert` and use `https://kubernetes.default.svc` as the host.

2a. Enable KV engine
```bash
bao secrets enable kv-v2 -path=secret
```

3a. Create the ExternalSecretsOperator policy
```bash
bao policy write eso-policy - <<EOF
  path "secret/data/*" {
    capabilities = ["read", "list"]
  }
  path "secret/metadata/*" {
    capabilities = ["list"]
  }
EOF
```

4. Create the ESO role
```bash
bao write auth/kubernetes/role/eso-role \
        bound_service_account_names=vault-auth \
        bound_service_account_namespaces=vault \
        policies=eso-policy ttl=24h audience=vault
```

5. Create Kubernetes RBAC (see [rbac.yaml](../infra/kube/bao/rbac.yaml))
```bash
kubectl apply -f infra/kube/bao/rbac.yaml
```

6. Create SecretStore (see [secret-store.yaml](../infra/kube/bao/secret-store.yaml))
```bash
kubectl apply -f infra/kube/bao/secret-store.yaml
```


## Verification

> `bao path-help [engine]` to check path options

### roles/policies

list roles

```bash
bao list auth/[auth_type]/role
```

then get info on role to make sure it has the right policy

```bash
bao read auth/kubernetes/role/eso-role
```

then check policy; first, list policies

```bash
bao policy list
```

then, read specific policy aligning with role

```bash
bao policy read eso-policy
```

## References
- *https://external-secrets.io/v0.5.6/provider-hashicorp-vault/*
- *https://developer.hashicorp.com/vault/docs/deploy/kubernetes/csi*
- *https://developer.hashicorp.com/vault/tutorials/kubernetes-introduction/vault-secrets-operator?productSlug=vault&tutorialSlug=kubernetes&tutorialSlug=vault-secrets-operator*
