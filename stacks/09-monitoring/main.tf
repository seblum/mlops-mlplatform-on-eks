variable "domain_name" {
  type    = string
  default = ""
}

variable "grafana_git_client_id" {
  type    = string
  default = ""
}

variable "grafana_git_client_secret" {
  type      = string
  sensitive = true
  default   = ""
}

module "monitoring" {
  source            = "../../components/monitoring"
  name              = "monitoring"
  domain_name       = var.domain_name
  domain_suffix     = "/grafana"
  git_client_id     = var.grafana_git_client_id
  git_client_secret = var.grafana_git_client_secret
}
