stack {
  name        = "mlflow"
  description = "MLflow tracking server: custom Helm chart, RDS MySQL backend, S3 artifact store, IRSA, ExternalSecret for DB credentials."
  id          = "mlflow"
  tags        = ["app", "mlops"]

  after = [
    "../networking",
    "../external-secrets",
    "../rds-mlflow",
  ]
}
