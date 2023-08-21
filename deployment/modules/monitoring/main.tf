
##### PROMETHEUS
#
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

resource "helm_release" "prometheus-operator-crds" {
  chart            = "prometheus-operator-crds"
  name             = "prometheus-operator-crds"
  namespace        = var.namespace
  create_namespace = var.create_namespace

  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "5.1.0"
}



##### GRAFANA
#
resource "helm_release" "grafana" {
  chart            = "grafana"
  name             = "grafana"
  namespace        = var.namespace
  create_namespace = var.create_namespace

  repository = "https://grafana.github.io/helm-charts/"
  version    = "6.57.4"

  values = [
    yamlencode({
      service = {
        enabled = true
        type    = "ClusterIP"
      }
      ingress = {
        enabled = true
        annotations = {
          "external-dns.alpha.kubernetes.io/hostname"  = "mlplatform.seblum.me",
          "alb.ingress.kubernetes.io/scheme"           = "internet-facing",
          "alb.ingress.kubernetes.io/target-type"      = "ip",
          "kubernetes.io/ingress.class"                = "alb",
          "alb.ingress.kubernetes.io/group.name"       = "mlplatform",
          "alb.ingress.kubernetes.io/healthcheck-path" = "/api/health"
        }
        labels   = {}
        path     = "/grafana"
        pathType = "Prefix"
        hosts = [
          "mlplatform.seblum.me",
          "www.mlplatform.seblum.me"
        ]
      },
      datasources = {
        "datasources.yaml" = {
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
      },
      dashboardProviders = {
        "dashboardproviders.yaml" = {
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
      "grafana.ini" = {
        security = {
          allow_embedding = true # enables iframe loading
        },
        server = {
          domain : "mlplatform.seblum.me"
          root_url : "%(protocol)s://%(domain)s/grafana/"
          serve_from_sub_path : true
          # https://grafana.com/docs/grafana/latest/auth/github/#enable-github-in-grafana
        },
        "auth.github" = {
          enabled       = true
          allow_sign_up = true
          scopes        = "user:email,read:org"
          auth_url      = "https://github.com/login/oauth/authorize"
          token_url     = "https://github.com/login/oauth/access_token"
          api_url       = "https://api.github.com/user"
          # team_ids: grafana-user-team
          # allowed_organizations:
          client_id     = var.git_client_id
          client_secret = var.git_client_secret
        }
      }
  })]
}

