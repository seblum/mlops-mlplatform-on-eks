data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/eks/terraform.tfstate"
    region = "eu-central-1"
  }
}

variable "domain_name" {
  description = "Public domain name for the platform"
  type        = string
  default     = ""
}

module "networking" {
  source                  = "../../components/networking"
  namespace               = "kube-system"
  cluster_name            = data.terraform_remote_state.eks.outputs.cluster_name
  cluster_oidc_issuer_url = data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url
  domain_name             = var.domain_name
}
