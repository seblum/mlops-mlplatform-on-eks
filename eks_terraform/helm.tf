

resource "kubernetes_namespace" "namespace-monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "airflow" {
  metadata {
    name = "airflow"
  }
}
resource "kubernetes_secret" "airflow_db_credentials" {
  metadata {
    name = "airflow-db-auth"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }
data = {
    "postgresql-password" = module.rds.rds_password
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "airflow-postgres-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Enable postgres access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "monitoring"
  
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "40.0.0"
  # chart      = "/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/distribution/prometheus"

  # values = "path to distributions"
  # kann das auch mit values.yaml geändert werden?
  # set {
  #   name  = "service.type"
  #   value = "NodePort"
  # }
}


# resource "helm_release" "grafana" {
#   name       = "grafana"
#   namespace  = "monitoring"
  
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "grafana" 
#   version    = "6.32.2"
#   # chart      = "/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/distribution/grafana"

#   set {
#     name  = "service.type"
#     value = "NodePort"
#   }
# }


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


resource "helm_release" "airflow" {
  name       = "airflow"
  namespace  = "airflow"
  
  repository = "https://airflow-helm.github.io/charts"
  chart      = "airflow"
  version    = "8.6.1"

  values     = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/helm/airflow/values.yaml")}"]
  # values = "path to distributions"
  # kann das auch mit values.yaml geändert werden?

  # need to enable this for other postgresql usage
  # set {
  #   name  = "postgresql.enabled"
  #   value = "false"
  # }
}