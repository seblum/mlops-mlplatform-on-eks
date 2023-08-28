output "s3_log_bucket_name" {
  description = "Name of the S3 bucket for log storage"
  value       = aws_s3_bucket.s3_log_storage.bucket
}

output "s3_log_bucket_role_arn" {
  description = "ARN of the IAM role for the S3 log bucket"
  value       = aws_iam_role.s3_log_bucket_role.arn
}
