resource "helm_release" "jupyterhub" {
  name             = var.name
  namespace        = var.name
  create_namespace = var.create_namespace

  repository = "https://jupyterhub.github.io/helm-chart/"
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [yamlencode({
    singleuser = {
      defaultUrl = "/lab"
      image = {
        name = "seblum/jupyterhub-server"
        tag  = "latest"
      },
      lifecycleHooks = {
        postStart = {
          exec = {
            command = ["git", "clone", "${var.git_repository_url}"]
          }
        }
      },
      extraEnv = {
        "MLFLOW_TRACKING_URI" = "http://mlflow-service.mlflow.svc.cluster.local"
      }
    },
    ingress = {
      enabled : true
      annotations = {
        "external-dns.alpha.kubernetes.io/hostname" = "${var.domain_name}"
        "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
        "alb.ingress.kubernetes.io/target-type"     = "ip"
        "kubernetes.io/ingress.class"               = "alb"
        "alb.ingress.kubernetes.io/group.name"      = "mlplatform"
      }
      hosts = ["${var.domain_name}", "www.${var.domain_name}"]
    },
    proxy = {
      service = {
        type = "ClusterIP"
      }
      secretToken = var.proxy_secret_token
    }
    cull = {
      enabled = true
      users   = true
    }
    hub = {
      baseUrl = "/${var.domain_suffix}"
      config = {
        GitHubOAuthenticator = {
          client_id          = var.git_client_id
          client_secret      = var.git_client_secret
          oauth_callback_url = "http://${var.domain_name}/${var.domain_suffix}/hub/oauth_callback"
        }
        JupyterHub = {
          authenticator_class = "github"
        }
      }
    }
  })]
}
