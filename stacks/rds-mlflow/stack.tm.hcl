stack {
  name        = "rds-mlflow"
  description = "RDS MySQL instance for MLflow backend store."
  id          = "rds-mlflow"
  tags        = ["infra", "database"]

  after = [
    "../vpc",
    "../eks",
  ]
}
