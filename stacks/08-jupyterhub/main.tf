data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/eks/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "mlflow" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/mlflow/terraform.tfstate"
    region = "eu-central-1"
  }
}

variable "domain_name" {
  type    = string
  default = ""
}

variable "jupyterhub_git_client_id" {
  type    = string
  default = ""
}

variable "jupyterhub_git_client_secret" {
  type      = string
  sensitive = true
  default   = ""
}

variable "jupyterhub_proxy_secret_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "git_sync_repository_url" {
  type    = string
  default = ""
}

module "jupyterhub" {
  source           = "../../components/jupyterhub"
  name             = "jupyterhub"
  cluster_name     = data.terraform_remote_state.eks.outputs.cluster_name
  cluster_endpoint = data.terraform_remote_state.eks.outputs.cluster_endpoint
  domain_name      = var.domain_name
  domain_suffix    = "jupyterhub"

  git_repository_url = var.git_sync_repository_url
  git_client_id      = var.jupyterhub_git_client_id
  git_client_secret  = var.jupyterhub_git_client_secret
  proxy_secret_token = var.jupyterhub_proxy_secret_token

  helm_chart_repository = "https://jupyterhub.github.io/helm-chart/"
  helm_chart_name       = "jupyterhub"
  helm_chart_version    = "3.3.8"

  mlflow_tracking_uri = data.terraform_remote_state.mlflow.outputs.mlflow_tracking_uri
}
