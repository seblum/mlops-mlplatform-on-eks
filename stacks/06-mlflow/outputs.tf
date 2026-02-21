output "mlflow_tracking_uri" {
  description = "MLflow internal cluster service URI"
  value       = module.mlflow.mlflow_tracking_uri
}

output "mlflow_s3_policy_arn" {
  description = "IAM policy ARN for the MLflow S3 artifact bucket"
  value       = module.mlflow.mlflow_s3_policy_arn
}
