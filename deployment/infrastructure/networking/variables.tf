variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = ""
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL of the EKS Cluster"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Namespace to launch Prometheus & Grafana"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = ""
}
