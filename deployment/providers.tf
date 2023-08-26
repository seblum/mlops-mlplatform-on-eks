provider "aws" {
  region     = local.aws_region
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY

}


provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}


provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    # aws eks get-token might be outdated
    # try aws sts get-caller-identity
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
      command     = "aws"
    }
  }
}


terraform {
  # required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "mlplatform-terraform-state"
    # rename in next run
    key    = "terraform.tfstate"
    region = "eu-central-1"
    #dynamodb_table = "aws-locks"
    encrypt = true
  }

}
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 3.20.0"
#     }

#     random = {
#       source  = "hashicorp/random"
#       version = "3.1.0"
#     }

#     local = {
#       source  = "hashicorp/local"
#       version = "2.1.0"
#     }

#     null = {
#       source  = "hashicorp/null"
#       version = "3.1.0"
#     }

#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = ">= 2.6.1"
#     }
#   }

#   required_version = ">= 0.14"
# }
