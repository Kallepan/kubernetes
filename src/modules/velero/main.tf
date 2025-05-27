
resource "kubernetes_secret_v1" "veloro" {
  depends_on = [kubernetes_namespace_v1.velero_namespace]
  metadata {
    name      = "cloud-credentials"
    namespace = "velero"
  }
  data = {
    "cloud" = <<EOF
[default]
aws_access_key_id=admin
aws_secret_access_key=password
EOF
  }
  type = "Opaque"
}

resource "kubernetes_namespace_v1" "velero_namespace" {
  metadata {
    name = "velero"
    labels = {
      "kubernetes.io/metadata.name" = "velero"
      "name"                        = "argo"
    }
  }
}

resource "helm_release" "velero" {
  depends_on   = [kubernetes_namespace_v1.velero_namespace, kubernetes_secret_v1.veloro]
  name         = "velero"
  namespace    = "velero"
  force_update = true
  repository   = "https://vmware-tanzu.github.io/helm-charts"
  chart        = "velero"
  version      = "8.5.0"

  values = [
    "${templatefile("${path.module}/values.yaml", {
      bucket_name        = "default"
      velero_version     = "1.14.0"
      aws_plugin_version = "1.10.0"
    })}"
  ]
}
