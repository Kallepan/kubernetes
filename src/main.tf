### Pull secret
resource "kubernetes_secret_v1" "homelab_registry_secret" {
  metadata {
    name      = "homelab-registry-secret"
    namespace = "default"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.homelab_registry_url}" = {
          auth = base64encode("${var.homelab_registry_username}:${var.homelab_registry_token}")
        }
      }
    })
  }
  
type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret_v1" "ne_registry_secret" {
  metadata {
    name      = "ne-registry-secret"
    namespace = "default"
  }
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.ne_registry_url}" = {
          auth = base64encode("${var.ne_registry_username}:${var.ne_registry_token}")
        }
      }
    })
  }
  type = "kubernetes.io/dockerconfigjson"
}

module "cert_manager" {
  source = "./modules/cert-manager"
}

module "istio" {
  source = "./modules/istio"
}

module "kserve" {
  source = "./modules/kserve"
}
