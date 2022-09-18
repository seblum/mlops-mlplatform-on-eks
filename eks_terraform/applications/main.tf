
### ------------ ###
###     HELM     ###
### ------------ ###

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_authority)
    # aws eks get-token might be outdated
    # try aws sts get-caller-identity
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}



resource "helm_release" "prometheus" {
  name      = "prometheus"
  namespace = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "40.0.0"
}

resource "helm_release" "airflow" {
  name      = "airflow"
  namespace = "airflow"

  repository = "https://airflow-helm.github.io/charts"
  chart      = "airflow"
  version    = "8.6.1"

  values = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/airflow/values.yaml")}"]
}

resource "helm_release" "mlflow" {
  name      = "mlflow"
  namespace = "mlflow"

  repository = "https://community-charts.github.io/helm-charts"
  chart      = "community-charts/mlflow"
  version    = "0.7.13"

  values = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/mlflow/values.yaml")}"]
}
