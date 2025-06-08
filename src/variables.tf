variable "kubernetes_config_path" {
  description = "Path to the Kubernetes config file"
  type        = string
  default     = "~/.kube/config"
}

### Homelab Registry Variables
variable "homelab_registry_url" {
  description = "Homelab registry URL"
  type        = string
}

variable "homelab_registry_token" {
  description = "Access token for the homelab registry"
  type        = string
  sensitive   = true
}

variable "homelab_registry_username" {
  description = "Username for the homelab registry"
  type        = string
}

### NE Registry Variables
variable "ne_registry_url" {
  description = "Registry URL"
  type        = string
}

variable "ne_registry_token" {
  description = "Access token for accessing the registry"
  type        = string
  sensitive   = true
}

variable "ne_registry_username" {
  description = "Username for accessing the registry"
  type        = string
}