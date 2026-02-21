stack {
  name        = "jupyterhub"
  description = "JupyterHub: official Helm chart v3.x with GitHub OAuth, MLflow tracking URI injected."
  id          = "jupyterhub"
  tags        = ["app", "notebook"]

  after = [
    "../networking",
    "../external-secrets",
    "../mlflow",
  ]
}
