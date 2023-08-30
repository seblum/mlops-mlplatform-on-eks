output "mlflow_tracking_uri" {
  description = "MLflow tracking URI"
  value       = "${helm_release.mlflow.metadata[0].name}.${helm_release.mlflow.metadata[0].namespace}.svc.cluster.local"
}

output "mlflow_s3_policy_arn" {
  description = "Policiy ARN to access the mlflow S3 artifact bucket"
  value       = aws_iam_policy.mlflow_s3_policy.arn

}