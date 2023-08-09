resource "helm_release" "prometheus" {
  chart            = "prometheus"
  name             = "prometheus"
  namespace        = var.namespace
  create_namespace = var.create_namespace

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

  repository = "https://grafana.github.io/helm-charts/"
  version    = "6.57.4"

  values = [
    yamlencode({
      datasources = {
        yaml = {
          apiVersion = 1
          datasources = [
            {
              name      = "Prometheus"
              type      = "prometheus"
              url       = "http://prometheus-server.monitoring.svc.cluster.local"
              access    = "proxy"
              isDefault = true
            }
          ]
        }
      }
      service = {
        enabled = true
        type    = "LoadBalancer"
      }
      # admin:
      #   ## Name of the secret. Can be templated.
      #   existingSecret: ""
      #   userKey: admin-user
      #   passwordKey: admin-password
      dashboardProviders = {
        yaml = {
          apiVersion = 1
          providers = [
            {
              name   = "'default'"
              orgId  = 1
              folder = "''"
              type : "file"
              disableDeletion : false
              editable : true
              options = {
                path = "/var/lib/grafana/dashboards/default"
              }
            }
          ]
        }
      }
      dashboards = {
        default = {
          prometheus-stats = {
            gnetId     = 2
            revision   = 2
            datasource = "Prometheus"
          }
          prometheus-stats-2 = {
            gnetId     = 315
            datasource = "Prometheus"
          }
          k8s-cluster = {
            gnetId     = 6417
            datasource = "Prometheus"
          }
        }
      }
  })]
  # "${file("${path.module}/helm/grafana/values.yaml")}"
}