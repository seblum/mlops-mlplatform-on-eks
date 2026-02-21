locals {
  cluster_name = "mlplatform-eks-cluster"
  vpc_name     = "mlplatform-vpc"
}

module "vpc" {
  source       = "../../components/vpc"
  cluster_name = local.cluster_name
  vpc_name     = local.vpc_name
}
