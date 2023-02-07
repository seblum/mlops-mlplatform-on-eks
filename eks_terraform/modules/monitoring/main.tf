
# resource "kubernetes_namespace" "namespace-monitoring" {
#   metadata {
#     name = "monitoring"
#   }
# }


# resource "helm_release" "prometheus" {
#   name      = "prometheus"
#   namespace = "monitoring"

#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-prometheus-stack"
#   version    = "40.0.0"
# }
