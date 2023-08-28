locals {
  
}
# Prepare Container Registry
module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "mlflow-pyfunc"

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



# Sagemaker

resource "aws_iam_policy" "sagemaker_access" {
  name        = "sagemaker_access"
  description = "sagemaker_access policy for cluster mlflow"

  policy = file("${path.module}/SagemakerFullAccess.json")
}


resource "aws_iam_role" "sagemaker_access_role" {
  name                 = "sagemaker_access_role"
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

resource "aws_iam_role_policy_attachment" "yatai_data_bucket_role_policy" {
  role       = aws_iam_role.sagemaker_access_role.name
  policy_arn = aws_iam_policy.sagemaker_access.arn
}
