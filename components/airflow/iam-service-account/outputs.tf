output "airflow_service_account_role_arn" {
  description = "ARN of the IAM role for the Airflow Service account to assume"
  value       = aws_iam_role.airflow_service_account_role.arn
}
