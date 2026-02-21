stack {
  name        = "07-airflow"
  description = "Airflow: community Helm chart (KubernetesExecutor), RDS PostgreSQL, S3 data bucket, EFS logs, IRSA, ExternalSecrets for credentials, Kubernetes Secrets Backend enabled."
  id          = "airflow"
  tags        = ["app"]

  after = [
    "../03-networking",
    "../04-external-secrets",
    "../06-mlflow",
  ]
}
