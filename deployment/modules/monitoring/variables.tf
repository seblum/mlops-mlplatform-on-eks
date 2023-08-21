variable "name" {
  type = string
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





variable "namespace" {
  type        = string
  description = "Namespace to launch Prometheus & Grafana"
  default     = "monitoring"
}

variable "create_namespace" {
  type        = bool
  description = "Should the namespace be created, if it does not exists?"
  default     = true
}

variable "git_client_id" {

}

variable "git_client_secret" {

}