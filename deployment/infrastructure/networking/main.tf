module "external-dns" {
  source                  = "./external-dns"
  namespace               = var.namespace
  name                    = "external-dns"
  helm_chart_name         = "external-dns"
  helm_chart_version      = "6.20.4"
  cluster_name            = var.cluster_name
  cluster_oidc_issuer_url = var.cluster_oidc_issuer_url
  domain_name             = var.domain_name
}


module "application-load-balancer" {
  source                  = "./application-load-balancer"
  name                    = "aws-load-balancer-controller"
  helm_chart_name         = "aws-load-balancer-controller"
  helm_chart_version      = "1.4.1"
  namespace               = var.namespace
  cluster_name            = var.cluster_name
  cluster_oidc_issuer_url = var.cluster_oidc_issuer_url
}