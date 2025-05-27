resource "kubernetes_namespace_v1" "mongodb" {
  metadata {
    name = "mongodb"
    labels = {
      app = "mongodb"
    }
  }
}
resource "helm_release" "mongodb_operator" {
  depends_on = [kubernetes_namespace_v1.mongodb]

  name       = "mongodb-operator"
  chart      = "enterprise-operator"
  repository = "https://mongodb.github.io/helm-charts"
  namespace  = "mongodb"

  wait             = true
  create_namespace = false

  values = [
    file("${path.module}/values/mongodb-operator.yaml"),
  ]
}