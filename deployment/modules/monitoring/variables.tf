variable "create_namespace" {
  type        = bool
  description = "Should the namespace be created if it does not exist?"
  default     = true
}

variable "git_client_id" {
  description = "Client ID for Git integration"
  type        = string
  default     = ""
}

variable "git_client_secret" {
  description = "Client secret for Git integration"
  type        = string
  default     = ""
}

# variable "helm_chart_repository" {
#   type        = string
#   description = "Repository URL or path to the location of the helm repo"
# }

# variable "helm_chart_name" {
#   type        = string
#   description = "Name of the helm chart"
# }

# variable "helm_chart_version" {
#   type        = string
#   description = "Version of the helm chart"
# }

variable "name" {
  description = "Name"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Namespace to launch Prometheus & Grafana"
  type        = string
  default     = "monitoring"
}
