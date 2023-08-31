locals {
  cluster_name                         = var.cluster_name
  cluster_namespace                    = "kube-system"
  ebs_csi_service_account_name         = "ebs-csi-controller-sa"
  ebs_csi_service_account_role_name    = "${var.cluster_name}-ebs-csi-controller"
  autoscaler_service_account_name      = "autoscaler-controller-sa"
  autoscaler_service_account_role_name = "${var.cluster_name}-autoscaler-controller"

  nodegroup_t3_small_label  = "t3_small"
  nodegroup_t3_medium_label = "t3_medium"
  nodegroup_t3_large_label  = "t3_large"
  eks_asg_tag_list_nodegroup_t3_small_label = {
    "k8s.io/cluster-autoscaler/enabled" : true
    "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned"
    "k8s.io/cluster-autoscaler/node-template/label/role" : local.nodegroup_t3_small_label
  }

  eks_asg_tag_list_nodegroup_t3_medium_label = {
    "k8s.io/cluster-autoscaler/enabled" : true
    "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned"
    "k8s.io/cluster-autoscaler/node-template/label/role" : local.nodegroup_t3_medium_label
  }

  eks_asg_tag_list_nodegroup_t3_large_label = {
    "k8s.io/cluster-autoscaler/enabled" : true
    "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned"
    "k8s.io/cluster-autoscaler/node-template/label/role" : local.nodegroup_t3_large_label
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" : "${local.nodegroup_t3_large_label}:NoSchedule"
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
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name              = local.cluster_name
  cluster_version           = var.eks_cluster_version
  cluster_enabled_log_types = ["api", "controllerManager", "scheduler"]

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  manage_aws_auth_configmap       = true

  aws_auth_users = var.aws_auth_users_list

  cluster_addons = {
    coredns = {
      most_recent = true
    },
    kube-proxy = {
      most_recent = true
    },
    aws-ebs-csi-driver = {
      service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.ebs_csi_service_account_role_name}"
    },
    vpc-cni = {
      most_recent              = true
      before_compute           = true
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }

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

      min_size      = 0
      max_size      = 5
      desired_size  = 0
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

      min_size      = 4
      max_size      = 6
      desired_size  = 4
      capacity_type = "ON_DEMAND"
      labels = {
        role = local.nodegroup_t3_medium_label
      }
      tags = {
        "k8s.io/cluster-autoscaler/enabled"                  = "true"
        "k8s.io/cluster-autoscaler/${local.cluster_name}"    = "owned"
        "k8s.io/cluster-autoscaler/node-template/label/role" = "${local.nodegroup_t3_medium_label}"
      }
    }
    group_t3_large = {
      name = "ng2_t3_large"

      instance_types = ["t3.large"]

      min_size      = 0
      max_size      = 3
      desired_size  = 0
      capacity_type = "ON_DEMAND"
      labels = {
        role = local.nodegroup_t3_large_label
      }
      taints = [
        {
          key    = "dedicated"
          value  = local.nodegroup_t3_large_label
          effect = "NO_SCHEDULE"
        }
      ]
      tags = {
        "k8s.io/cluster-autoscaler/enabled"                       = "true"
        "k8s.io/cluster-autoscaler/${local.cluster_name}"         = "owned"
        "k8s.io/cluster-autoscaler/node-template/label/role"      = "${local.nodegroup_t3_large_label}"
        "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "${local.nodegroup_t3_large_label}:NoSchedule"
      }
    }
  }
  tags = local.tags
}

#  Role for Service Account
module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
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

resource "kubernetes_annotations" "ebs-no-default-storageclass" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  force       = "true"

  metadata {
    name = "gp2"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }
}


################################################################################
#
# EFS
#
resource "helm_release" "aws_efs_csi_driver" {
  chart      = "aws-efs-csi-driver"
  name       = "aws-efs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  set {
    name  = "controller.serviceAccount.create"
    value = true
  }
  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.attach_efs_csi_role.iam_role_arn
  }
  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }
}

module "attach_efs_csi_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name             = "efs-csi"
  attach_efs_csi_policy = true
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
}

resource "aws_security_group" "allow_nfs" {
  name        = "allow nfs for efs"
  description = "Allow NFS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "NFS from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidr_blocks
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

### MODULE EFS IS NOT WORKING AT THE MOMENT; NEED TO SET EVERYYTHING MANUALLY

# module "efs" {
#   source  = "terraform-aws-modules/efs/aws"
#   version = "~> 1.0"

#   creation_token = local.cluster_name
#   name           = local.cluster_name

#   # Mount targets / security group
#   mount_targets = { for k, v in toset(range(length(var.azs))) :
#     element(var.azs, k) => { subnet_id = element(var.private_subnets, k) }
#   }
#   security_group_description = "${var.cluster_name} EFS security group"
#   security_group_vpc_id      = var.vpc_id
#   security_group_rules = {
#     vpc = {
#       # relying on the defaults provided for EFS/NFS (2049/TCP + ingress)
#       description = "NFS ingress from VPC private subnets"
#       cidr_blocks = var.private_subnets_cidr_blocks
#     }
#   }

#   # Access point(s)
#   access_points = {
#     posix_example = {
#       name = "posix-example"
#       posix_user = {
#         gid            = 1001
#         uid            = 1001
#         secondary_gids = [1002]
#       }

#     }
#     root_example = {
#       root_directory = {
#         path = "/"
#         creation_info = {
#           owner_gid   = 1001
#           owner_uid   = 1001
#           permissions = "755"
#         }
#       }
#     }
#   }
#   #tags = var.tags
# }

resource "aws_efs_file_system" "stw_node_efs" {
  creation_token = "efs-for-stw-node"
}

resource "aws_efs_mount_target" "stw_node_efs_mt_0" {
  file_system_id  = aws_efs_file_system.stw_node_efs.id
  subnet_id       = var.private_subnets[0]
  security_groups = [aws_security_group.allow_nfs.id]
}

resource "aws_efs_mount_target" "stw_node_efs_mt_1" {
  file_system_id  = aws_efs_file_system.stw_node_efs.id
  subnet_id       = var.private_subnets[1]
  security_groups = [aws_security_group.allow_nfs.id]
}

resource "aws_efs_mount_target" "stw_node_efs_mt_2" {
  file_system_id  = aws_efs_file_system.stw_node_efs.id
  subnet_id       = var.private_subnets[2]
  security_groups = [aws_security_group.allow_nfs.id]
}

resource "kubernetes_storage_class_v1" "efs" {
  metadata {
    name = "efs"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "efs.csi.aws.com"
  parameters = {
    provisioningMode = "efs-ap"                            # Dynamic provisioning
    fileSystemId     = aws_efs_file_system.stw_node_efs.id # module.efs.id
    directoryPerms   = "777"
  }

  mount_options = [
    "iam"
  ]
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

resource "aws_autoscaling_group_tag" "nodegroup_t3_large" {
  for_each               = local.eks_asg_tag_list_nodegroup_t3_large_label
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
  cluster_oidc_issuer_url         = module.eks.cluster_oidc_issuer_url
  autoscaler_service_account_name = local.autoscaler_service_account_name
}
