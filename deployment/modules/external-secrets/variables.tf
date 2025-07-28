variable "release_name" {
  description = "Helm release name for the External Secrets Operator"
  type        = string
  default     = "external-secrets"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy the operator"
  type        = string
  default     = "external-secrets"
}

variable "chart_repository" {
  description = "Helm repository URL for the chart"
  type        = string
  default     = "https://charts.external-secrets.io"
}

variable "chart_name" {
  description = "Chart name"
  type        = string
  default     = "external-secrets"
}

variable "chart_version" {
  description = "Chart version"
  type        = string
  default     = "0.9.11"
}

variable "create_service_account" {
  description = "Whether to create a service account"
  type        = bool
  default     = true
}

variable "service_account_name" {
  description = "Name of the service account (if not created, must exist)"
  type        = string
  default     = "external-secrets-sa"
}

variable "irsa_role_arn" {
  description = "IAM role ARN for IRSA to fetch secrets from AWS Secrets Manager"
  type        = string
  default     = ""
}

variable "labels" {
  description = "Additional labels to apply"
  type        = map(string)
  default     = {}
}
