variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state."
  type        = string
  default     = "mlplatform-terraform-state"
}

variable "table_name" {
  description = "The name of the DynamoDB table for Terraform state locking."
  type        = string
  default     = "mlplatform-terraform-locks"
}
