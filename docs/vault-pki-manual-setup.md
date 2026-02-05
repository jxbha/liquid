# Certificate Management with OpenBao

## Overview
> from: https://cert-manager.io/docs/configuration/vault/#option-2-vault-authentication-method-use-kubernetes-auth

The goal is to set up a cert-manager issuer, in order to receive Certificate resources and use OpenBao to either generate or renew the relevant TLS certs and keys.

## Prerequisites
- Kubernetes Cluster in a Ready state
- OpenBao instance in a Ready state
- bao CLI access

## Steps
1a. Enable kubernetes auth (or ensure enabled)
```bash
bao auth enable kubernetes
```

1b. Retrieve Kubernetes CA cert (if bao is external to kubernetes - see below)
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

> Kubernetes auth config may likely already be configured from KV engine setup. If so, skip all of step 1.

2a. Enable PKI engine
```bash
bao secrets enable pki
```

2b. Configure sane TTL maximum for PKI engine
```bash
bao secrets tune -max-lease-ttl=87600h pki
```

2c. Generate Root Certificate
```bash
bao write pki/root/generate/internal common_name="liquid CA" ttl=87600h
```

3a. Create the issuer policy
```bash
bao policy write pki - <<EOF
  path "pki/sign/liquid-internal" {
    capabilities = ["create", "update"]
  }
EOF
```

4a. Create the issuer role
```bash
bao write auth/kubernetes/role/issuer \
        bound_service_account_names=vault-issuer \
        bound_service_account_namespaces=cert-manager \
        policies=vault-issuer \
        ttl=1m
```

4b. Create the PKI role (defines certificate constraints)
```bash
bao write pki/roles/liquid-internal \
        allowed_domains=jbernh.xyz,svc.cluster.local \
        allow_subdomains=true \
        allow_any_name=true \
        require_cn=false \
        use_csr_common_name=false \
        max_ttl=2160h
```

5. Create Kubernetes RBAC (see [rbac.yaml](../infra/kube/ssl/rbac.yaml))
```bash
kubectl apply -f infra/kube/ssl/rbac.yaml
```

6. Create Issuer (see [clusterissuer.yaml](../infra/kube/ssl/clusterissuer.yaml))
```bash
kubectl apply -f infra/kube/ssl/clusterissuer.yaml
```

Certificates are now ready to be requested by using the Vault issuer named vault-issuer.

## Verification

### secrets/engines

list engines

```
bao secrets list
```

List PKI roles:

```
bao list pki/roles
```

Read PKI role:

```
bao read pki/roles/ROLE_NAME
```

List issuers:

```
bao list pki/issuers
```

Read issuer:

```
bao read pki/issuer/ISSUER_ID
```

## References
- *https://cert-manager.io/docs/usage/*
- *https://openbao.org/docs/secrets/pki/*
- *https://github.com/jeffsanicola/vault-policy-guide*
