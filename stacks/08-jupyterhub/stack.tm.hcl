stack {
  name        = "08-jupyterhub"
  description = "JupyterHub: official Helm chart v3.x with GitHub OAuth and MLflow URI injected."
  id          = "jupyterhub"
  tags        = ["app"]

  after = [
    "../03-networking",
    "../06-mlflow",
  ]
}
