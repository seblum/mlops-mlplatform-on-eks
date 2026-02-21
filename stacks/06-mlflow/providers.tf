// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
provider "aws" {
  region = "eu-central-1"
}
data "aws_eks_cluster" "main" {
  name = "mlplatform-eks-cluster"
}
data "aws_eks_cluster_auth" "main" {
  name = "mlplatform-eks-cluster"
}
provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  host                   = data.aws_eks_cluster.main.endpoint
  token                  = data.aws_eks_cluster_auth.main.token
}
provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    host                   = data.aws_eks_cluster.main.endpoint
    token                  = data.aws_eks_cluster_auth.main.token
  }
}
