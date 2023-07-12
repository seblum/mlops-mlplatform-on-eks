variable "s3_force_destroy" {
  type        = bool
  description = "Set to true to disable protection against s3 bucket being destroyed. Use only for dev!"
  default     = false
}

variable "namespace" {
  type = string
}
variable "s3_data_bucket_name" {

}

variable "s3_data_bucket_secret_name" {

}