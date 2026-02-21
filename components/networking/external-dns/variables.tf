variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL of the EKS Cluster"
  type        = string
}

variable "namespace" {
  description = "Namespace"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "name" {
  description = "Name"
  type        = string
}

variable "helm_chart_name" {
  description = "Name of the helm chart"
  type        = string
}

variable "helm_chart_version" {
  description = "Version of the helm chart"
  type        = string
}
