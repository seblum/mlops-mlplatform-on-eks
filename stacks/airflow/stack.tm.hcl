stack {
  name        = "airflow"
  description = "Airflow: community Helm chart with KubernetesExecutor, RDS PostgreSQL, EFS logs, git-sync, IRSA, ExternalSecrets for DB/Git/OAuth credentials. Kubernetes Secrets Backend enabled."
  id          = "airflow"
  tags        = ["app", "orchestration"]

  after = [
    "../networking",
    "../external-secrets",
    "../rds-airflow",
    "../mlflow",
  ]
}
