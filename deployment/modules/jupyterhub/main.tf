# create a database

# configure the Amazon EBS CSI Driver with a IAM Role for Service Accounts for least privileged containers.

resource "helm_release" "jupyterhub" {
  name             = var.name
  namespace        = var.name
  create_namespace = var.create_namespace

  repository = "https://jupyterhub.github.io/helm-chart/"
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [
    "${file("${path.module}/helm/values.yaml")}"
  ]

  # set {
  #   name  = "singleuser.lifecycleHooks.postStart.exec.command"
  #   value = ["git", "clone", "https://github.com/seblum/Airflow_DAGs.git"]
  #   type = list
  # }
  set {
    name  = "singleuser.extraEnv[0].name"
    value = "MLFLOW_TRACKING_URI"
  }
  set {
    name  = "singleuser.extraEnv[0].value"
    value = "http://${var.mlflow_tracking_uri}"
  }

  set {
    name = "hub.config.Authenticator.admin_users"
    value = "{var.admin_user_list}"
  }
  # hub:
  # config:
  #     JupyterHub:
  #       admin_access: false
  #       authenticator_class: dummy
  #     Authenticator:
  #       admin_users:

}
