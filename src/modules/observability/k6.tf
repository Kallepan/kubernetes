resource "helm_release" "k6_operator" {
  depends_on = [kubernetes_namespace_v1.observability]

  name       = "k6-operator"
  chart      = "k6-operator"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "observability"

  wait             = true
  create_namespace = false

  values = [
    file("${path.module}/values/k6.yaml"),
  ]
}

resource "kubernetes_config_map_v1" "k6_tests" {
  depends_on = [helm_release.k6_operator]
  metadata {
    name      = "k6-tests"
    namespace = kubernetes_namespace_v1.observability.metadata[0].name
  }

  data = {
    "test-run.js" = file("${path.module}/files/test-run.js")
  }
}

resource "kubectl_manifest" "k6_test_run" {
  depends_on = [helm_release.k6_operator, kubernetes_config_map_v1.k6_tests]
  yaml_body  = file("${path.module}/manifests/test-run.yaml")
}
