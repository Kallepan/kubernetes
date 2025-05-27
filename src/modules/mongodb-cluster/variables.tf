variable "mongodb_user" {
  description = "MongoDB user"
  type        = string
  sensitive   = true
}

variable "mongodb_public_api_key" {
  description = "MongoDB public API key"
  type        = string
  sensitive   = true
}

variable "mongodb_org_id" {
  description = "MongoDB organization ID"
  type        = string
  sensitive   = true
}

# Ops Manager credentials
variable "mongodb_ops_manager_username" {
  description = "Ops Manager username"
  type        = string
  sensitive   = true
}
variable "mongodb_ops_manager_password" {
  description = "Ops Manager password"
  type        = string
  sensitive   = true
}