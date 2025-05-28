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
    file("${path.module}/values/kyverno.yaml"),
  ]
}

resource "kubernetes_namespace_v1" "reports_server" {
  metadata {
    name = "reports-server"
  }

  count = var.install_report_server ? 1 : 0
}
resource "helm_release" "reports_server" {
  count = var.install_report_server ? 1 : 0

  name = "reports-server"
  chart = "reports-server"
  repository = "https://kyverno.github.io/reports-server"
  namespace = kubernetes_namespace_v1.reports_server[count.index].metadata[0].name

  wait             = true
  create_namespace = false
  values = [
    file("${path.module}/values/reports-server.yaml"),
  ]
}