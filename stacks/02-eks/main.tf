data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  cluster_name = "mlplatform-eks-cluster"
}

module "eks" {
  source       = "../../components/eks"
  cluster_name = local.cluster_name

  eks_cluster_version         = "1.32"
  vpc_id                      = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets             = data.terraform_remote_state.vpc.outputs.private_subnets
  azs                         = data.terraform_remote_state.vpc.outputs.azs
  private_subnets_cidr_blocks = data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks
  security_group_id_one       = [data.terraform_remote_state.vpc.outputs.worker_group_mgmt_one_id]
  security_group_id_two       = [data.terraform_remote_state.vpc.outputs.worker_group_mgmt_two_id]

  aws_auth_users_list = []
}
