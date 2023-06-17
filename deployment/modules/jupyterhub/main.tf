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
    "${file("${path.module}/../../applications/jupyterhub/values.yaml")}"
  ]

  # set {
  #   name  = "singleuser.lifecycleHooks.postStart.exec.command"
  #   value = ["git", "clone", "https://github.com/seblum/Airflow_DAGs.git"]
  #   type = list
  # }

}
