


# resource "helm_release" "prometheus" {
#   name      = var.tag_name # "prometheus"
#   namespace = var.tag_name

#   repository = var.helm_chart_repository # "https://prometheus-community.github.io/helm-charts"
#   chart      = var.helm_chart_name # "kube-prometheus-stack"
#   version    = var.helm_chart_version #"40.0.0"
# }


resource "helm_release" "prometheus" {
  chart            = "prometheus"
  name             = "prometheus"
  namespace        = var.namespace
  create_namespace = var.create_namespace

  # https://github.com/prometheus-community/helm-charts/
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "19.7.2"

  values = [
    yamlencode({
      alertmanager = {
        enabled = false
      }
      prometheus-pushgateway = {
        enabled = false
      }
      server = {
        persistentVolume = {
          enabled = false
        }
      }
    })
  ]
}


resource "helm_release" "grafana" {
  chart            = "grafana"
  name             = "grafana"
  namespace        = var.namespace
  create_namespace = var.create_namespace

  # https://github.com/prometheus-community/helm-charts/
  repository = "https://grafana.github.io/helm-charts/"
  version    = "6.57.4"

  values = [
    "${file("${path.module}/helm/grafana/values.yaml")}"
  ]

}