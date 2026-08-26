path "sys/auth" {
  #capabilities = ["create", "read", "update", "sudo", "list"]
  capabilities = ["create", "update", "sudo", "read", "delete"]
}

path "sys/auth/*" {
  capabilities = ["create", "update", "sudo", "read", "delete"]
}

path "sys/mounts/*" {
  capabilities = ["read", "create", "update", "sudo", "delete"]
}

path "sys/mounts" {
  capabilities = ["list", "read", "create", "delete", "update"]
}

path "sys/policies/*" {
  capabilities = ["read", "create", "update", "delete"]
}

path "auth/kubernetes/config" {
  capabilities = ["read", "update", "create", "delete"]
}

path "auth/kubernetes/role/*" {
  capabilities = ["read", "create", "update", "delete", "sudo"]
}

path "pki/roles/*" {
  capabilities = ["read", "create", "update", "delete"]
}

path "secret/data/*" {
  capabilities = ["create", "update", "delete", "read", "list"]
}

path "secret/metadata/*" {
  capabilities = ["list"]
}

path "secret/config" {
  capabilities = ["create", "read", "update", "delete"]
}

path "pki/sign/*" {
  capabilities = ["create", "update", "delete", "read"]
}

path "pki/root/generate/internal" {
  capabilities = ["create", "update", "delete", "read"]
}

path "pki/issuers/generate/root/*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "auth/token/create" {
  capabilities = ["create", "update", "sudo", "read", "delete"]
}
