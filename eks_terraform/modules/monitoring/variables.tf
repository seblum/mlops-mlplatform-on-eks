variable "tag_name" {}

variable "helm_chart_repository" {
  type        = string
  description = "Repository URL or path to the location of the helm repo"
}

variable "helm_chart_name" {
  type        = string
  description = "Name of the helm chart"
}

variable "helm_chart_version" {
  type        = string
  description = "Version of the helm chart"
}
