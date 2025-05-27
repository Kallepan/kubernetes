resource "kubernetes_namespace_v1" "cattle_system" {
  metadata {
    name = "cattle-system"
  }
}

resource "helm_release" "rancher" {
  depends_on = [kubernetes_namespace_v1.cattle_system]
  name       = "rancher"
  repository = "https://releases.rancher.com/server-charts/latest"
  chart      = "rancher"

  namespace = kubernetes_namespace_v1.cattle_system.metadata[0].name

  values = [
    file("${path.module}/values.yaml"),
  ]
  wait             = true
  create_namespace = false
}

resource "kubernetes_service_v1" "rancher_lb_service" {
  metadata {
    name      = "rancher-lb"
    namespace = kubernetes_namespace_v1.cattle_system.metadata[0].name
  }
  spec {
    selector = {
      app = "rancher"
    }
    type = "LoadBalancer"
    port {
      name = "http"
      port = 8080
    }
    port {
      name = "https"
      port = 8443
    }
  }
}