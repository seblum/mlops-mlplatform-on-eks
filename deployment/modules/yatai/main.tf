locals {
  s3_bucket_name                                = "${var.name_prefix}-${var.namespace}-${var.s3_bucket_name}"
  yatai_service_account_role_name               = "yatai-role"
  yatai_service_account_name                    = "yatai-sa"
  yatai_image_builder_service_account_role_name = "yatai-image-builder-role"
  yatai_image_builder_service_account_name      = "yatai-image-builder-sa"
  namespace_yatai                               = "${var.namespace}-system"
  namespace_yatai_image_builder                 = "${var.namespace}-image-builder"
  namespace_yatai_deployment                    = "${var.namespace}-deployment"
}

data "aws_caller_identity" "current" {}

resource "kubernetes_namespace" "yatai" {
  metadata {
    name = "${var.namespace}"
  }
}

resource "kubernetes_namespace" "yatai-system" {
  metadata {
    name = local.namespace_yatai
  }
}

resource "kubernetes_namespace" "yatai-image-builder" {
  metadata {

    name = local.namespace_yatai_image_builder
  }
}

resource "kubernetes_namespace" "yatai-deployment" {
  metadata {
    name = local.namespace_yatai_deployment
  }
}

# S3

# create s3 bucket for artifacts
resource "aws_s3_bucket" "yatai" {
  bucket = local.s3_bucket_name
  # tags          = var.tags
  force_destroy = var.s3_force_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_state_encryption" {
  bucket = aws_s3_bucket.yatai.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# Postgres
resource "random_password" "rds_password" {
  #count  = var.generate_db_password ? 1 : 0
  length  = 16
  special = false
}

# create rds for s3
module "rds-yatai" {
  source                      = "../../infrastructure/rds"
  vpc_id                      = var.vpc_id
  private_subnets             = var.private_subnets
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  rds_port                    = var.rds_port
  rds_name                    = var.rds_name
  rds_password                = coalesce(var.rds_password, random_password.rds_password.result)
  rds_engine                  = var.rds_engine
  rds_engine_version          = var.rds_engine_version
  rds_instance_class          = var.rds_instance_class
  storage_type                = var.rds_storage_type
  max_allocated_storage       = var.rds_max_allocated_storage
}

# resource "kubernetes_secret" "yatai_s3_secret" {
#   metadata {
#     name      = "yatai_s3_secret"
#     namespace = local.namespace_yatai
#   }
#   data = {
#     "username" = var.git_username
#     "password" = var.git_token
#   }
# }


module "yatai_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.11.1"
  create_role                   = true
  role_name                     = local.yatai_service_account_role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.yatai_iam_sa.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.namespace_yatai}:${local.yatai_service_account_name}"]
}

resource "aws_iam_policy" "yatai_iam_sa" {
  name        = local.yatai_service_account_name
  description = "Yatai policy for accessing S3"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*Object",
          "s3:GetObjectVersion",
          "s3:*"
        ],
        "Resource" : [
          "arn:aws:s3:::${local.s3_bucket_name}/*",
          "arn:aws:s3:::${local.s3_bucket_name}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListBucketVersions"
        ],
        "Resource" : [
          "arn:aws:s3:::${local.s3_bucket_name}/*",
          "arn:aws:s3:::${local.s3_bucket_name}"
        ],
      }
  ] })
}




######### YATAI #########

# Yatai Helm Chart

resource "helm_release" "yatai" {
  name             = var.name
  namespace        = local.namespace_yatai
  create_namespace = var.create_namespace

  repository = "https://bentoml.github.io/helm-charts"
  chart      = "yatai"
  version    = var.helm_chart_version

  values = [yamlencode({
    postgresql = {
      host     = module.rds-yatai.rds_host
      port     = var.rds_port
      user     = module.rds-yatai.rds_username
      database = module.rds-yatai.rds_dbname
      password = module.rds-yatai.rds_password
    },
    s3 = {
      endpoint   = aws_s3_bucket.yatai.bucket_domain_name
      region     = aws_s3_bucket.yatai.region
      bucketName = aws_s3_bucket.yatai.bucket
    },
    serviceAccount = {
      create = true,
      name   = "yatai-sa"
      annotations = {
        "eks.amazonaws.com/role-arn" = "${module.yatai_role.iam_role_arn}"
      }
    },
    ingress = {
      # className = "alb"
      enabled = true
      hosts = [
        {
          host  = "mlplatform.seblum.me"
          paths = ["/bentoml", "/yatai"]
        },
        {
          host  = "www.mlplatform.seblum.me"
          paths = ["/bentoml", "/yatai"]
        }
      ],
      annotations = {
        "external-dns.alpha.kubernetes.io/hostname" = "mlplatform.seblum.me"
        "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
        "alb.ingress.kubernetes.io/target-type"     = "ip"
        "kubernetes.io/ingress.class"               = "alb"
        "alb.ingress.kubernetes.io/group.name"      = "mlplatform"
      }
    }
  })]
}



######### CERT MANAGER AND METRICS SERVER #########

# needed for yatai-image-builder and yatai-deployment

# TODO: install certifications manager
# kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
resource "helm_release" "certifications-manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.12.3"

  values = [yamlencode({
    installCRDs = true
  })]
}


resource "helm_release" "metrics_server" {
  name = "metrics-server"
  # namespace        = var.namespace
  create_namespace = true

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.11.0"
  depends_on = [helm_release.certifications-manager]
}





######### YATAI IMAGE BUILDER #########

# Prepare Container Registry



module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "yatai-bentos"

  #repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "yatai_image_builder_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.11.1"
  create_role                   = true
  role_name                     = local.yatai_image_builder_service_account_role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.yatai_image_builder_iam_sa.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.namespace_yatai_image_builder}:${local.yatai_image_builder_service_account_name}"]
}

resource "aws_iam_policy" "yatai_image_builder_iam_sa" {
  name        = local.yatai_image_builder_service_account_name
  description = "Yatai policy for accessing S3"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "ecr:PutImageTagMutability",
          "ecr:StartImageScan",
          "ecr:DescribeImageReplicationStatus",
          "ecr:ListTagsForResource",
          "ecr:UploadLayerPart",
          "ecr:BatchDeleteImage",
          "ecr:ListImages",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:DeleteRepository",
          "ecr:CompleteLayerUpload",
          "ecr:TagResource",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:ReplicateImage",
          "ecr:GetLifecyclePolicy",
          "ecr:PutLifecyclePolicy",
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:PutImageScanningConfiguration",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DeleteLifecyclePolicy",
          "ecr:PutImage",
          "ecr:UntagResource",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:StartLifecyclePolicyPreview",
          "ecr:InitiateLayerUpload",
          "ecr:GetRepositoryPolicy"
        ],
        "Resource" : "${module.ecr.repository_arn}"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetRegistryPolicy",
          "ecr:BatchImportUpstreamImage",
          "ecr:CreateRepository",
          "ecr:DescribeRegistry",
          "ecr:DescribePullThroughCacheRules",
          "ecr:GetAuthorizationToken",
          "ecr:PutRegistryScanningConfiguration",
          "ecr:CreatePullThroughCacheRule",
          "ecr:DeletePullThroughCacheRule",
          "ecr:GetRegistryScanningConfiguration",
          "ecr:PutReplicationConfiguration"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# 2. Create an IAM role for the service account
resource "kubernetes_service_account" "this" {
  metadata {
    name      = "yatai-image-builder-pod"
    namespace = local.namespace_yatai_image_builder
    labels    = { "yatai.ai/yatai-image-builder-pod" = true }
    annotations = {
      "eks.amazonaws.com/role-arn" = "ROLE_ARN"
    }
  }
  automount_service_account_token = true
}

# kubectl label serviceaccount -n yatai yatai-image-builder-pod yatai.ai/yatai-image-builder-pod=true


resource "helm_release" "yatai-image-builder-crds" {
  name      = "yatai-image-builder-crds"
  namespace = local.namespace_yatai_image_builder
  # create_namespace = var.create_namespace

  repository = "https://bentoml.github.io/helm-charts"
  chart      = "yatai-image-builder-crds"
  depends_on = [helm_release.metrics_server]
}



resource "helm_release" "yatai-image-builder" {
  name      = "yatai-image-builder"
  namespace = local.namespace_yatai_image_builder
  # create_namespace = var.create_namespace

  repository = "https://bentoml.github.io/helm-charts"
  chart      = "yatai-image-builder"
  version    = "1.1.13"

  values = [yamlencode({
    dockerRegistry = {
      server = module.ecr.repository_url
      # inClusterServer     = "",
      username            = "",
      password            = "",
      secure              = true,
      bentoRepositoryName = "yatai-bentos"
    }
  })]
  depends_on = [helm_release.metrics_server]
}




######### YATAI DEPLOYMENT #########

resource "helm_release" "yatai-deployment-crds" {
  name      = "yatai-deployment-crds"
  namespace = local.namespace_yatai_deployment
  # create_namespace = var.create_namespace

  repository = "https://bentoml.github.io/helm-charts"
  chart      = "yatai-deployment-crds"
  depends_on = [helm_release.metrics_server]
}



resource "helm_release" "yatai-deployment" {
  name      = "yatai-deployment"
  namespace = local.namespace_yatai_deployment
  # create_namespace = var.create_namespace

  repository = "https://bentoml.github.io/helm-charts"
  chart      = "yatai-deployment"
  version    = "1.1.13"

  values = [yamlencode({
    layers = {
      network = {
        ingressClass = "alb",
        # ingressAnnotations = {
        #   "external-dns.alpha.kubernetes.io/hostname" = "mlplatform.seblum.me"
        #   "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
        #   "alb.ingress.kubernetes.io/target-type"     = "ip"
        #   #"kubernetes.io/ingress.class"               = "alb"
        #   "alb.ingress.kubernetes.io/group.name"      = "mlplatform"
        # },
        # ingressPath = "/serve"
        # domainSuffix = "mlplatform.seblum.me"
      }
    }
    bentoDeploymentNamespaces = ["${var.namespace}"]
  })]
  depends_on = [helm_release.metrics_server]
}



# Yatai Deployment Helm Chart
# The yatai-deployment component is an add-on on top of yatai for deploying bentos to Kubernetes.


# Yatai Image Builder
# actually done via mlflow, but install it nevertheless

# Metrics
# https://docs.yatai.io/en/latest/observability/metrics.html

