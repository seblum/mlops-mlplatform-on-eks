output "mlflow_tracking_uri" {
  value = "${helm_release.mlflow.metadata[0].name}.${helm_release.mlflow.metadata[0].namespace}.svc.cluster.local"
}