resource "vault_mount" "pki" {
  path = "pki"
  type = "pki"
}

resource "vault_pki_secret_backend_root_cert" "liquid" {
  depends_on  = [vault_mount.pki]
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = "liquid CA"
  issuer_name = "liquid-root"
  ttl         = "315360000" # 10 years
}

resource "vault_policy" "pki" {
  name   = "pki"
  policy = file("${path.module}/policies/pki-policy.hcl")
}

resource "vault_pki_secret_backend_role" "issuer" {
  name                = "issuer"
  backend             = vault_mount.pki.path
  allowed_domains     = ["jbernh.xyz", "svc.cluster.local"]
  allow_subdomains    = true
  require_cn          = false
  use_csr_common_name = false
  ttl                 = 129600
}

resource "vault_kubernetes_auth_backend_role" "issuer" {
  backend                          = data.vault_auth_backend.kubernetes.path
  role_name                        = "issuer"
  bound_service_account_names      = ["vault-issuer"]
  bound_service_account_namespaces = ["cert-manager"]
  token_ttl                        = 60
  token_policies                   = ["default", "pki"]
  audience                         = "vault"
}
