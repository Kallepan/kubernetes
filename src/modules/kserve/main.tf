resource "helm_release" "kserve_crd" {
  depends_on = [ kubernetes_namespace_v1.kserve ]
  name       = "kserve-crd"
  chart      = "kserve-crd"
  repository = "oci://ghcr.io/kserve/charts"
  namespace  = "kserve"

  version = var.kserve_version

  create_namespace = false
  wait             = true
}

resource "helm_release" "kserve" {
  depends_on = [helm_release.kserve_crd]
  name       = "kserve"
  chart      = "kserve"
  repository = "oci://ghcr.io/kserve/charts"
  namespace  = "kserve"

  version = var.kserve_version

  create_namespace = false
  wait             = true

  values = [
    file("${path.module}/values.yaml"),
  ]
}

resource "kubernetes_namespace_v1" "kserve" {
  metadata {
    name = "kserve"
    labels = {
      app = "kserve"
    }
  }
}


