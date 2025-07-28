output "s3_bucket_id" {
  description = "The ID of the S3 bucket for Terraform state."
  value       = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}
