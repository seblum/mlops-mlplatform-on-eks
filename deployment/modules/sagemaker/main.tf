locals {
  dockerhub_repository_name = var.dockerhub_repository_name
  repository_model_tag      = var.repository_model_tag
  ecr_repository_name       = "mlflow-sagemaker-deployment"
  iam_name_sagemaker_access = "sagemaker-access"

  sagemaker_dashboard_read_access_user_name = "sagemaker-dashboard-read-access-user"
  sagemaker_dashboard_read_access_role_name = "sagemaker-dashboard-read-access-role"
  sagemaker_dashboard_read_access_secret    = "sagemaker-dashboard-read-access-secret"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_policy" "AmazonSageMakerFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}
data "aws_iam_policy" "AmazonSageMakerReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSageMakerReadOnly"
}

# Create Container Registry
module "ecr" {
  source          = "terraform-aws-modules/ecr/aws"
  repository_name = local.ecr_repository_name

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
  repository_force_delete = true
  # tags = {
  #   Terraform   = "true"
  #   Environment = "dev"
  # }
}

# mlflow sagemaker build-and-push-container --build --no-push -c mlflow-sagemaker-deployment
# https://mlflow.org/docs/latest/cli.html
resource "null_resource" "docker_packaging" {
  provisioner "local-exec" {
    command = <<EOF
	    docker pull "${local.dockerhub_repository_name}:${local.repository_model_tag}"
      docker tag "${local.dockerhub_repository_name}:${local.repository_model_tag}" "${module.ecr.repository_url}:${local.repository_model_tag}"
      aws ecr get-login-password --region ${data.aws_region.current.name} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com
	    docker push "${module.ecr.repository_url}:${local.repository_model_tag}"
	    EOF
  }

  # triggers = {
  #   "run_at" = timestamp()
  # }
  depends_on = [
    module.ecr,
  ]
}

# Access role to allow access to Sagemaker
resource "aws_iam_role" "sagemaker_access_role" {
  name                 = "${local.iam_name_sagemaker_access}-role"
  max_session_duration = 28800

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "sagemaker.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  EOF
  # tags = {
  #   tag-key = "tag-value"
  # }
}

resource "aws_iam_role_policy_attachment" "sagemaker_access_role_policy" {
  role       = aws_iam_role.sagemaker_access_role.name
  policy_arn = data.aws_iam_policy.AmazonSageMakerFullAccess.arn
}


# Helm Deployment
resource "helm_release" "sagemaker-dashboard" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace

  chart = "${path.module}/helm/"
  values = [yamlencode({
    deployment = {
      image     = "seblum/streamlit-sagemaker-app:v1.0.0",
      name      = "sagemaker-streamlit",
      namespace = "${var.namespace}"
    },
    ingress = {
      host = "mlplatform.seblum.me"
      path = "/sagemaker"
    },
    secret = {
      AWS_REGION            = "${data.aws_region.current.name}"
      AWS_ACCESS_KEY_ID     = "${aws_iam_access_key.sagemaker_dashboard_read_access_user_credentials.id}"
      AWS_SECRET_ACCESS_KEY = "${aws_iam_access_key.sagemaker_dashboard_read_access_user_credentials.secret}"
      AWS_ROLE_NAME         = "${aws_iam_role.sagemaker_dashboard_read_access_role.name}"
    }
  })]
}

# Access role to allow access to Sagemaker
resource "aws_iam_role" "sagemaker_dashboard_read_access_role" {
  name                 = local.sagemaker_dashboard_read_access_role_name
  max_session_duration = 28800

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.sagemaker_dashboard_read_access_user.name}"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  EOF
  # tags = {
  #   tag-key = "tag-value"
  # }
}

resource "aws_iam_role_policy_attachment" "sagemaker_dashboard_read__access_role_policy" {
  role       = aws_iam_role.sagemaker_dashboard_read_access_role.name
  policy_arn = data.aws_iam_policy.AmazonSageMakerReadOnlyAccess.arn
}

resource "aws_iam_user" "sagemaker_dashboard_read_access_user" {
  name = local.sagemaker_dashboard_read_access_user_name
  path = "/"
}

resource "aws_iam_access_key" "sagemaker_dashboard_read_access_user_credentials" {
  user = aws_iam_user.sagemaker_dashboard_read_access_user.name
}
