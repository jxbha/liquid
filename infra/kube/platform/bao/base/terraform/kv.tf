resource "vault_policy" "eso-policy" {
  name   = "eso-policy"
  policy = file("${path.module}/policies/eso-policy.hcl")
}

resource "vault_mount" "kvv2" {
  path    = "secret"
  type    = "kv"
  options = { version = "2" }
}

resource "vault_kv_secret_backend_v2" "secret" {
  mount                = vault_mount.kvv2.path
  max_versions         = 5
  delete_version_after = 12600
}

resource "vault_kubernetes_auth_backend_role" "eso-role" {
  backend                          = data.vault_auth_backend.kubernetes.path
  role_name                        = "eso-role"
  bound_service_account_names      = ["vault-auth"]
  bound_service_account_namespaces = ["vault"]
  token_ttl                        = 86400
  token_policies                   = ["default", "eso-policy"]
  audience                         = "vault"
}
