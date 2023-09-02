
variable "cluster_name" {
  type        = string
  description = "Name of the EKS Cluster"
}

variable "cluster_namespace" {
  type        = string
  description = "Namespace of the EKS Cluster Autoscaler"

}
variable "cluster_oidc_issuer_url" {
  type        = string
  description = "cluster OIDC issuer url"
}

variable "autoscaler_service_account_name" {
  type        = string
  description = "Name of the cluster autoscaler service account"
}