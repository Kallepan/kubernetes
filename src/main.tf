### Pull secret
resource "kubernetes_secret_v1" "registry_secret" {
  metadata {
    name      = "registry-secret"
    namespace = "default"
  }
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_url}" = {
          auth = base64encode("${var.registry_username}:${var.registry_token}")
        }
      }
    })
  }
  type = "kubernetes.io/dockerconfigjson"
}

module "cert-manager" {
  source = "./modules/cert-manager"
}

module "kyverno" {
  source = "./modules/kyverno"
}