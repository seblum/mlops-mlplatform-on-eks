# create a database

# configure the Amazon EBS CSI Driver with a IAM Role for Service Accounts for least privileged containers.

# https://archive.eksworkshop.com/beginner/080_scaling/deploy_ca/
# https://github.com/jupyterhub/zero-to-jupyterhub-k8s
# https://hub.jupyter.org/helm-chart/
# https://nils-braun.medium.com/deploying-a-free-multi-user-browser-only-ide-in-just-a-few-minutes-d891f803224b
# https://z2jh.jupyter.org/en/latest/jupyterhub/installation.html

resource "helm_release" "jupyterhub" {
  name             = var.name
  namespace        = var.name
  create_namespace = var.create_namespace

  repository = "https://jupyterhub.github.io/helm-chart/"
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  #values = ["eks_terraform/applications/airflow/values.yaml"]
  #   values     = [file("${path.root}/helm/airflow.yml")]
  #values = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/jupyterhub/values.yaml")}"]
  values = [
    "${file("${path.module}/../../applications/jupyterhub/values.yaml")}"
    ]
    #"${file("${path.root}/../applications/jupyterhub/values.yml")}"
  #     file("${path.module}/helm-values/fluentbit/values.yaml")
  #     templatefile("${path.module}/helm-values/values.yaml", {

  # set {
  #   name  = "singleuser.lifecycleHooks.postStart.exec.command"
  #   value = ["git", "clone", "https://github.com/seblum/Airflow_DAGs.git"]
  #   type = list
  # }

}
