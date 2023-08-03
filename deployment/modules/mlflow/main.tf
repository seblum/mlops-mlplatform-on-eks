locals {
  mlflow_s3_bucket_name = "${var.name_prefix}-${var.namespace}-${var.mlflow_s3_bucket_name}"
}

data "aws_caller_identity" "current" {}
# TODO: set namespace before ressourcs right

# create s3 bucket for artifacts
resource "aws_s3_bucket" "mlflow" {
  bucket = var.mlflow_s3_bucket_name
  # tags          = var.tags
  force_destroy = var.s3_force_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_state_encryption" {
  bucket = aws_s3_bucket.mlflow.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.eks_oidc_provider}"
resource "aws_iam_role" "mlflow_s3_role" {
  name = "${var.namespace}-s3-access-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Effect": "Allow",
        "Principal" : {
          "Federated" : [
            "${var.oidc_provider_arn}" 
          ]
        }
      }
    ]
  }
  EOF
  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy" "mlflow_s3_policy" {
  name = "${var.namespace}-s3-access-policy"
  path = "/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*Object",
          "s3:GetObjectVersion"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.mlflow_s3_bucket_name}/*",
          "arn:aws:s3:::${var.mlflow_s3_bucket_name}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListBucketVersions"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.mlflow_s3_bucket_name}/*",
          "arn:aws:s3:::${var.mlflow_s3_bucket_name}"
        ],
        # "Condition" : {
        #   "StringLike" : {
        #     "s3:prefix" : [
        #       "test/*"
        #     ]
        #   }
        # }
      }
  ] })
}

resource "aws_iam_role_policy_attachment" "mlflow_s3_policy" {
  role       = aws_iam_role.mlflow_s3_role.name
  policy_arn = aws_iam_policy.mlflow_s3_policy.arn
}


resource "random_password" "rds_password" {
  #count  = var.generate_db_password ? 1 : 0
  length = 16
  # MLFlow has troubles using special characters
  special = false
}

# create rds for s3
module "rds-mlflow" {
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
  storage_type                = var.storage_type
  max_allocated_storage       = var.max_allocated_storage
}


resource "helm_release" "mlflow" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace

  chart = "${path.module}/helm/"
  values = [
    "${file("${path.module}/helm/values.yaml")}"
  ]

  set {
    name  = "RDS_USERNAME"
    value = module.rds-mlflow.rds_username
  }
  set {
    name  = "RDS_PASSWORD"
    value = module.rds-mlflow.rds_password
  }
  set {
    name  = "RDS_HOST"
    value = module.rds-mlflow.rds_host
  }
  set {
    name  = "RDS_PORT"
    value = var.rds_port
  }
  set {
    name  = "ARTIFACT_S3_BUCKET"
    value = var.mlflow_s3_bucket_name
  }
  set {
    name  = "ARTIFACT_S3_KEY_PREFIX"
    value = "test"
  }
  set {
    name  = "ARTIFACT_S3_ROLE_ARN"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.mlflow_s3_role.name}" # "arn:aws:iam::855372857567:role/mlflow-s3-access-mlflow-role"
  }
  set {
    name  = "DB_NAME"
    value = module.rds-mlflow.rds_dbname
  }
}


