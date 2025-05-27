variable "kubernetes_config_path" {
  description = "Path to the Kubernetes config file"
  type        = string
  default     = "~/.kube/config"
}

### Registry Variables
variable "registry_url" {
  description = "Registry URL"
  type        = string
}

variable "registry_token" {
  description = "Access token for accessing the registry"
  type        = string
  sensitive   = true
}

variable "registry_username" {
  description = "Username for accessing the registry"
  type        = string
}