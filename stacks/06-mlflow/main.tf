data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/eks/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "random_string" "name_prefix" {
  length  = 12
  upper   = false
  special = false
}

variable "domain_name" {
  type    = string
  default = ""
}

module "mlflow" {
  source            = "../../components/mlflow"
  name              = "mlflow"
  namespace         = "mlflow"
  s3_bucket_name    = "artifact-bucket"
  s3_force_destroy  = true
  oidc_provider_arn = data.terraform_remote_state.eks.outputs.oidc_provider_arn
  name_prefix       = random_string.name_prefix.result
  domain_name       = var.domain_name
  domain_suffix     = "/mlflow"

  vpc_id                      = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets             = data.terraform_remote_state.vpc.outputs.private_subnets
  private_subnets_cidr_blocks = data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks

  rds_port                  = 5432
  rds_name                  = "mlflow"
  rds_engine                = "mysql"
  rds_engine_version        = "8.0.40"
  rds_instance_class        = "db.t3.micro"
  rds_storage_type          = "gp2"
  rds_max_allocated_storage = 500
}
