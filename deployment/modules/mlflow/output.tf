output "mlflow_tracking_uri" {
  description = "MLflow tracking URI"
  value       = "${helm_release.mlflow.metadata[0].name}.${helm_release.mlflow.metadata[0].namespace}.svc.cluster.local"
}
