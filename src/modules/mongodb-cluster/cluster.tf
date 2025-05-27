data "kubernetes_namespace_v1" "mongodb" {
  metadata {
    name = "mongodb"
  }
}

resource "kubernetes_secret_v1" "ops_manager_secret" {
  metadata {
    name      = "ops-manager-admin-user-credentials"
    namespace = data.kubernetes_namespace_v1.mongodb.metadata[0].name
  }

  type = "Opaque"

  data = {
    Username  = "${var.mongodb_ops_manager_username}"
    Password  = "${var.mongodb_ops_manager_password}"
    FirstName = "Admin"
    LastName  = "User"
  }
}

resource "kubectl_manifest" "ops_manager" {
  depends_on = [kubernetes_secret_v1.ops_manager_secret]

  yaml_body = templatefile("${path.module}/manifests/ops-manager.yaml", {
    namespace   = data.kubernetes_namespace_v1.mongodb.metadata[0].name
    secret_name = kubernetes_secret_v1.ops_manager_secret.metadata[0].name
  })
}

resource "kubernetes_config_map_v1" "mongodb_cm" {
  metadata {
    name      = "my-project"
    namespace = data.kubernetes_namespace_v1.mongodb.metadata[0].name
  }

  data = {
    baseUrl = "http://mongodb-ops-manager-svc.mongodb.svc.cluster.local:8080"
    orgId   = var.mongodb_org_id
  }
}

resource "kubernetes_secret_v1" "mongodb_secret" {
  metadata {
    name      = "organization-secret"
    namespace = data.kubernetes_namespace_v1.mongodb.metadata[0].name
  }

  type = "Opaque"

  data = {
    user         = var.mongodb_user
    publicApiKey = var.mongodb_public_api_key
  }
}

resource "kubectl_manifest" "mongo_db_cluster" {
  depends_on = [kubernetes_config_map_v1.mongodb_cm, kubernetes_secret_v1.mongodb_secret, kubectl_manifest.ops_manager]

  yaml_body = templatefile("${path.module}/manifests/mongo-cluster.yaml", {
    namespace            = data.kubernetes_namespace_v1.mongodb.metadata[0].name
    mongo_configmap_name = kubernetes_config_map_v1.mongodb_cm.metadata[0].name
    mongo_secret_name    = kubernetes_secret_v1.mongodb_secret.metadata[0].name
  })
}
