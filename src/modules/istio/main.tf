resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  depends_on = [kubernetes_namespace_v1.istio_system]

  name       = "istio-base"
  chart      = "base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  namespace  = "istio-system"

  wait             = true
  create_namespace = false

  values = [
    file("${path.module}/values/istio-base.yaml"),
  ]
}

resource "helm_release" "istiod" {
  depends_on = [kubernetes_namespace_v1.istio_system]

  name       = "istiod"
  chart      = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  namespace  = "istio-system"

  wait             = true
  create_namespace = false

  values = [
    file("${path.module}/values/istiod.yaml"),
  ]
}

resource "helm_release" "istio_ingressgateway" {
  depends_on = [kubernetes_namespace_v1.istio_system]

  name       = "istio-ingressgateway"
  chart      = "gateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  namespace  = "istio-system"

  wait             = false
  create_namespace = false

  values = [
    file("${path.module}/values/istio-ingressgateway.yaml"),
  ]
}