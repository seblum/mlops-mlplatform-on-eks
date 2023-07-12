output "s3_log_bucket_role_arn" {
  value = aws_iam_role.s3_log_bucket_role.arn
}

output "s3_log_bucket_name" {
  value = aws_s3_bucket.s3_log_storage.bucket
}