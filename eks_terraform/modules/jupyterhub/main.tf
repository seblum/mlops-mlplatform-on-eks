

# https://archive.eksworkshop.com/beginner/080_scaling/deploy_ca/

https://github.com/jupyterhub/zero-to-jupyterhub-k8s
https://hub.jupyter.org/helm-chart/
https://nils-braun.medium.com/deploying-a-free-multi-user-browser-only-ide-in-just-a-few-minutes-d891f803224b
https://z2jh.jupyter.org/en/latest/jupyterhub/installation.html

resource "helm_release" "jupyterhub" {
  name      = var.tag_name
  namespace = var.tag_name

  repository = "https://jupyterhub.github.io/helm-chart/" #var.helm_chart_repository
  chart      = var.helm_chart_name # jupyterhub
  version    = var.helm_chart_version # 2.0.0

  #values = ["eks_terraform/applications/airflow/values.yaml"]
  #   values     = [file("${path.root}/helm/airflow.yml")]
  values = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/airflow/values.yaml")}"]

  set {
    name  = "externalDatabase.port"
    value = var.rds_port
  }

}
