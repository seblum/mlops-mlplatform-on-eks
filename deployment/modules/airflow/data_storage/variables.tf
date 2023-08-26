variable "namespace" {
  description = "Namespace"
  type        = string
  default     = ""
}

variable "s3_data_bucket_name" {
  description = "Name of the S3 Data Bucket"
  type        = string
  default     = ""
}

variable "s3_data_bucket_secret_name" {
  description = "Name of the secret containing credentials for the S3 Data Bucket"
  type        = string
  default     = ""
}

variable "s3_data_bucket_user_name" {
  description = "Username for accessing the S3 Data Bucket"
  type        = string
  default     = ""
}

variable "s3_force_destroy" {
  description = "Set to true to disable protection against S3 bucket being destroyed. Use only for dev!"
  type        = bool
  default     = false
}
