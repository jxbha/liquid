terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.8.0"
    }
  }
  backend "kubernetes" {
    secret_suffix     = "state"
    namespace         = "vault"
    in_cluster_config = true
  }
}
provider "vault" {
  address         = "http://openbao:8200"
  skip_tls_verify = true

  # https://registry.terraform.io/providers/hashicorp/vault/latest/docs#jwt
  auth_login_jwt {
    # https://kubernetes.io/docs/tasks/run-application/access-api-from-pod/#directly-accessing-the-rest-api
    jwt   = file("/var/run/secrets/kubernetes.io/serviceaccount/token")
    role  = "bootstrap-bao"
    mount = "kubernetes"
  }
}
