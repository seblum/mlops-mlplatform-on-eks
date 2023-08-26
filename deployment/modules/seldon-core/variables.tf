variable "name" {
  description = "Name"
  type        = string
  default     = ""
}

variable "create_namespace" {
  description = "Should the namespace be created, if it does not exist?"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = ""
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS Cluster"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Namespace of deployment"
  type        = string
  default     = ""
}

variable "helm_chart_repository" {
  description = "Repository URL or path to the location of the helm repo"
  type        = string
  default     = ""
}

variable "helm_chart_name" {
  description = "Name of the helm chart"
  type        = string
  default     = ""
}

variable "helm_chart_version" {
  description = "Version of the helm chart"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = ""
}

variable "domain_suffix" {
  description = "Domain suffix"
  type        = string
  default     = ""
}
