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
  namespace  = kubernetes_namespace_v1.observability.metadata[0].name

  wait             = true
  create_namespace = false

  values = [
    file("${path.module}/values/kube-prometheus-stack.yaml"),
  ]
}


resource "kubernetes_service_v1" "grafana_lb" {
  depends_on = [helm_release.kube_prometheus_stack]

  wait_for_load_balancer = false # Important for LoadBalancer services

  metadata {
    name      = "grafana-lb"
    namespace = kubernetes_namespace_v1.observability.metadata[0].name
    labels = {
      "app.kubernetes.io/instance" = "grafana"
      "app.kubernetes.io/name"     = "grafana"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "kube-prometheus-stack"
      "app.kubernetes.io/name"     = "grafana"
    }

    port {
      name        = "http-web"
      port        = 3000
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service_v1" "prometheus_lb" {
  depends_on = [helm_release.kube_prometheus_stack]

  wait_for_load_balancer = false # Important for LoadBalancer services

  metadata {
    name      = "prometheus-lb"
    namespace = kubernetes_namespace_v1.observability.metadata[0].name
    labels = {
      "app.kubernetes.io/name": "prometheus"
    }
  }
  spec {
    selector = {
        "app.kubernetes.io/name": "prometheus"
    }

    port {
      name        = "http-web"
      port        = 9090
      target_port = 9090
    }

    type = "LoadBalancer"
  }
}