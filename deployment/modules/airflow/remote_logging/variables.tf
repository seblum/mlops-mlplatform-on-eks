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

variable "s3_force_destroy" {
  description = "Set to true to disable protection against S3 bucket being destroyed. Use only for dev!"
  type        = bool
  default     = false
}

variable "s3_log_bucket_name" {
  description = "Name of the S3 Log Bucket"
  type        = string
  default     = ""
}
