resource "kubernetes_config_map_v1" "pbm_config" {
  metadata {
    name      = "pbm-config"
    namespace = data.kubernetes_namespace_v1.mongodb.metadata[0].name
  }

  data = {
    "pbm_config.yml" = <<EOT
storage:
    type: s3
    s3:
        region: eu-central-1
        bucket: default
        credentials:
            access-key-id: admin
            secret-access-key: password
EOT
  }
}
