variable "domain_name" {
  type    = string
  default = ""
}

module "dashboard" {
  source        = "../../components/dashboard"
  name          = "dashboard"
  namespace     = "dashboard"
  domain_name   = var.domain_name
  domain_suffix = "/main"
}
