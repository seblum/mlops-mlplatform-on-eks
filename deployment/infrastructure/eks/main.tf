locals {
  cluster_name                         = var.cluster_name
  cluster_namespace                    = "kube-system"
  ebs_csi_service_account_name         = "ebs-csi-controller-sa"
  ebs_csi_service_account_role_name    = "${var.cluster_name}-ebs-csi-controller"
  autoscaler_service_account_name      = "autoscaler-controller-sa"
  autoscaler_service_account_role_name = "${var.cluster_name}-autoscaler-controller"

  nodegroup_t3_small_label             = "t3_small"
  nodegroup_t3_medium_label            = "t3_medium"
  nodegroup_g4dn_xlarge_label          = "g4dn_xlarge"
  eks_asg_tag_list_nodegroup_t3_small_label = {
    "k8s.io/cluster-autoscaler/enabled" : true
    "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned"
    "k8s.io/cluster-autoscaler/node-template/label/role" : local.nodegroup_t3_small_label
  }

  eks_asg_tag_list_nodegroup_t3_medium_label = {
    "k8s.io/cluster-autoscaler/enabled" : true
    "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned"
    "k8s.io/cluster-autoscaler/node-template/label/role" : local.nodegroup_t3_medium_label
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" : "${local.nodegroup_t3_medium_label}:NoSchedule"
  }

  eks_asg_tag_list_nodegroup_g4dn_xlarge_label = {
    "k8s.io/cluster-autoscaler/enabled" : true
    "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned"
    "k8s.io/cluster-autoscaler/node-template/label/role" : local.nodegroup_g4dn_xlarge_label
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" : "${local.nodegroup_g4dn_xlarge_label}:NoSchedule"
  }

  tags = {
    Owner = "terraform"
  }
}

data "aws_caller_identity" "current" {}


################################################################################
#
# EKS
#

# TODO: node group in each availability zone
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name              = local.cluster_name
  cluster_version           = "1.24" # passed on via var
  cluster_enabled_log_types = ["api", "controllerManager", "scheduler"]

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  manage_aws_auth_configmap       = true

  # aws_auth_users            = local.cluster_users # add users in later step

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.ebs_csi_service_account_role_name}"
    }
    # external-dns = {

    # }
  }

  eks_managed_node_group_defaults = {
    ami_type                   = "AL2_x86_64"
    disk_size                  = 10
    iam_role_attach_cni_policy = true
    enable_monitoring          = true
  }

  eks_managed_node_groups = {
    group_t3_small = {
      name = "ng0_t3_small"

      instance_types = ["t3.small"]
      #instance_types = ["t3.medium"] # for testing airflow now.

      min_size      = 3
      max_size      = 6
      desired_size  = 4
      capacity_type = "ON_DEMAND"
      labels = {
        role = local.nodegroup_t3_small_label
      }
      tags = {
        "k8s.io/cluster-autoscaler/enabled"                  = "true"
        "k8s.io/cluster-autoscaler/${local.cluster_name}"    = "owned"
        "k8s.io/cluster-autoscaler/node-template/label/role" = "${local.nodegroup_t3_small_label}"
      }
    }
    group_t3_medium = {
      name = "ng1_t3_medium"

      instance_types = ["t3.medium"]

      min_size      = 0
      max_size      = 5
      desired_size  = 0
      capacity_type = "ON_DEMAND"
      labels = {
        role = local.nodegroup_t3_medium_label
      }
      taints = [
        {
          key    = "dedicated"
          value  = local.nodegroup_t3_medium_label
          effect = "NO_SCHEDULE"
        }
      ]
      tags = {
        "k8s.io/cluster-autoscaler/enabled"                       = "true"
        "k8s.io/cluster-autoscaler/${local.cluster_name}"         = "owned"
        "k8s.io/cluster-autoscaler/node-template/label/role"      = "${local.nodegroup_t3_medium_label}"
        "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "${local.nodegroup_t3_medium_label}:NoSchedule"
      }
    }
    # group_g4dn_xlarge = {
    #   name = "ng2_g4dn_xlarge"

    #   instance_types = ["g4dn.xlarge"]

    #   min_size      = 0
    #   max_size      = 1
    #   desired_size  = 0
    #   capacity_type = "ON_DEMAND"
    #   labels = {
    #     role = local.nodegroup_g4dn_xlarge_label
    #   }
    #   taints = [
    #     {
    #       key    = "dedicated"
    #       value  = local.nodegroup_g4dn_xlarge_label
    #       effect = "NO_SCHEDULE"
    #     }
    #   ]
    #   tags = {
    #     "k8s.io/cluster-autoscaler/enabled"                       = "true"
    #     "k8s.io/cluster-autoscaler/${local.cluster_name}"         = "owned"
    #     "k8s.io/cluster-autoscaler/node-template/label/role"      = "${local.nodegroup_g4dn_xlarge_label}"
    #     "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "${local.nodegroup_g4dn_xlarge_label}:NoSchedule"
    #   }
    # }
  }
  tags = local.tags
}



################################################################################
#
# EBS CSI controller
#
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



################################################################################
#
# EKS Cluster autoscaler
#

resource "aws_iam_policy" "node_additional" {
  name        = "${local.cluster_name}-additional"
  description = "${local.cluster_name} node additional policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "additional" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.node_additional.arn
  role       = each.value.iam_role_name
}


# Tags for the ASG to support cluster-autoscaler scale up from 0 for nodegroup2
resource "aws_autoscaling_group_tag" "nodegroup_t3_small" {
  for_each               = local.eks_asg_tag_list_nodegroup_t3_small_label
  autoscaling_group_name = element(module.eks.eks_managed_node_groups_autoscaling_group_names, 2)
  tag {
    key                 = each.key
    value               = each.value
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "nodegroup_t3_medium" {
  for_each               = local.eks_asg_tag_list_nodegroup_t3_medium_label
  autoscaling_group_name = element(module.eks.eks_managed_node_groups_autoscaling_group_names, 1)
  tag {
    key                 = each.key
    value               = each.value
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "nodegroup_g4dn_xlarge" {
  for_each               = local.eks_asg_tag_list_nodegroup_g4dn_xlarge_label
  autoscaling_group_name = element(module.eks.eks_managed_node_groups_autoscaling_group_names, 0)
  tag {
    key                 = each.key
    value               = each.value
    propagate_at_launch = true
  }
}

module "eks_autoscaler" {
  source                          = "./autoscaler"
  cluster_name                    = local.cluster_name
  cluster_namespace               = local.cluster_namespace
  aws_region                      = var.aws_region
  cluster_oidc_issuer_url         = module.eks.cluster_oidc_issuer_url
  autoscaler_service_account_name = local.autoscaler_service_account_name
}
