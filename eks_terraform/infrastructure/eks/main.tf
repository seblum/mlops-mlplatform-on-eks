locals {
  cluster_name                         = var.cluster_name
  cluster_namespace                    = "kube-system"
  ebs_csi_service_account_name         = "ebs-csi-controller-sa"
  ebs_csi_service_account_role_name    = "${var.cluster_name}-ebs-csi-controller"
  autoscaler_service_account_name      = "autoscaler-controller-sa"
  autoscaler_service_account_role_name = "${var.cluster_name}-autoscaler-controller"
}

data "aws_caller_identity" "current" {}


# TODO: node group in each availability zone
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets
  cluster_endpoint_public_access = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.ebs_csi_service_account_role_name}"
    },
    cluster-autoscaler = {
      service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.autoscaler_service_account_role_name}"
    }
  }

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-small"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-medium"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}


# EBS CSI controller
#
# https://stackoverflow.com/questions/74648632/how-do-i-use-the-aws-ebs-csi-driver-addon-when-using-the-aws-eks-terraform-modul
module "ebs_csi_controller_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.11.1"
  create_role                   = true
  role_name                     = local.ebs_csi_service_account_role_name
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.ebs_csi_controller_sa.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.cluster_namespace}:${local.ebs_csi_service_account_name}"]
}

resource "aws_iam_policy" "ebs_csi_controller_sa" {
  name        = local.ebs_csi_service_account_name
  description = "EKS ebs-csi-controller policy for cluster ${var.cluster_name}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DetachVolume",
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
  ] })
}

# EKS Cluster autoscaler
#
module "autoscaler_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.11.1"
  create_role                   = true
  role_name                     = local.autoscaler_service_account_role_name
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.autoscaler_controller_sa.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.cluster_namespace}:${local.autoscaler_service_account_name}"]
}

resource "aws_iam_policy" "autoscaler_controller_sa" {
  name        = local.autoscaler_service_account_name
  description = "EKS autoscaler controller policy for cluster ${var.cluster_name}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
  ] })
}
