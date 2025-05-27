resource "kubernetes_namespace_v1" "observability" {
  metadata {
    name = "observability"
  }
}

resource "helm_release" "kube_prometheus_stack" {
  depends_on = [kubernetes_namespace_v1.observability]

  name       = "kube-prometheus-stack"
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = "observability"

  wait             = true
  create_namespace = false

  values = [
    file("${path.module}/values/kube-prometheus-stack.yaml"),
  ]
}
