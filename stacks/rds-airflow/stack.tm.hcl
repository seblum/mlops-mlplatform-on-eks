stack {
  name        = "rds-airflow"
  description = "RDS PostgreSQL instance for Airflow metadata database."
  id          = "rds-airflow"
  tags        = ["infra", "database"]

  after = [
    "../vpc",
    "../eks",
  ]
}
