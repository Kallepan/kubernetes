resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace  = "cert-manager"

  create_namespace = true
  wait             = true

  set {
    name  = "crds.enabled"
    value = "true"
  }
}
