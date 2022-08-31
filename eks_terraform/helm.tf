
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    # aws eks get-token might be outdated
    # try aws sts get-caller-identity
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}


resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "monitoring"
  
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "36.6.1"
  # chart      = "/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/distribution/prometheus"

  # values = "path to distributions"
  # kann das auch mit values.yaml geändert werden?
  set {
    name  = "service.type"
    value = "NodePort"
  }
}


resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = "monitoring"
  
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana" 
  version    = "6.32.2"
  # chart      = "/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/distribution/grafana"

  set {
    name  = "service.type"
    value = "NodePort"
  }
}


# resource "helm_release" "kubernetes-dashboard" {

#   name = "kubernetes-dashboard"

#   repository = "https://kubernetes.github.io/dashboard/"
#   chart      = "kubernetes-dashboard"
#   namespace  = "default"

#   set {
#     name  = "service.type"
#     value = "LoadBalancer"
#   }

#   set {
#     name  = "protocolHttp"
#     value = "true"
#   }

#   set {
#     name  = "service.externalPort"
#     value = 80
#   }

#   set {
#     name  = "replicaCount"
#     value = 2
#   }

#   set {
#     name  = "rbac.clusterReadOnlyRole"
#     value = "true"
#   }
# }
