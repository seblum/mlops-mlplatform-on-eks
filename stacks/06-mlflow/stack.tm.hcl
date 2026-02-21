stack {
  name        = "06-mlflow"
  description = "MLflow: S3 artifact bucket, RDS MySQL backend, custom Helm chart, IRSA, Secrets Manager secret for DB credentials."
  id          = "mlflow"
  tags        = ["app"]

  after = [
    "../03-networking",
    "../04-external-secrets",
  ]
}
