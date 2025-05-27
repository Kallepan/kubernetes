resource "helm_release" "minio" {
  name       = "minio"
  chart      = "minio"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  namespace  = "minio"

  wait             = true
  create_namespace = true

  values = [
    file("${path.module}/values.yaml"),
  ]
}

resource "kubernetes_service_v1" "minio-svc" {
  depends_on = [helm_release.minio]

  wait_for_load_balancer = false # Important for LoadBalancer services

  metadata {
    name      = "minio-svc"
    namespace = "minio"
    labels = {
      "app.kubernetes.io/instance" = "minio"
      "app.kubernetes.io/name"     = "minio"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "minio"
      "app.kubernetes.io/name"     = "minio"
    }

    port {
      name        = "http-s3"
      port        = 9000
      target_port = 9000
    }

    port {
      name        = "http-console"
      port        = 9001
      target_port = 9001
    }

    type = "LoadBalancer"
  }
}