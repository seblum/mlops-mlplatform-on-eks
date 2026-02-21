variable "namespace" {
  description = "Namespace"
  type        = string
  default     = ""
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  type        = string
  default     = ""
}

variable "s3_mlflow_bucket_policy_arn" {
  description = "Policy ARN of an MLflow bucket to attach to a user"
  type        = string
  default     = "not-deployed"
}
