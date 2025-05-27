resource "kubernetes_namespace_v1" "kyverno_system" {
  metadata {
    name = "kyverno"
  }
}

resource "helm_release" "kyverno" {
  depends_on = [kubernetes_namespace_v1.kyverno_system]

  name       = "kyverno"
  chart      = "kyverno"
  repository = "https://kyverno.github.io/kyverno"
  namespace  = kubernetes_namespace_v1.kyverno_system.metadata[0].name

  wait             = true
  create_namespace = false

  values = [
    file("${path.module}/values.yaml"),
  ]
}