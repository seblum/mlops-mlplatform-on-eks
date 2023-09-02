locals {
  default_mlflow_sagemaker_policy_name = "default-mlflow-sagemaker-bucket-access-policy"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {} #
data "aws_iam_policy" "AmazonSageMakerFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role" "airflow_service_account_role" {
  name                 = "${var.namespace}-service-account-role"
  max_session_duration = 28800

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
  # tags = {
  #   tag-key = "tag-value"
  # }
}

# Policy for default S3 Bucket created by Sagemaker
resource "aws_iam_policy" "default_mlflow_sagemaker_bucket_policy" {
  name = local.default_mlflow_sagemaker_policy_name
  path = "/"

  policy = jsonencode(

    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "s3:ListStorageLensConfigurations",
            "s3:ListAccessPointsForObjectLambda",
            "s3:GetAccessPoint",
            "s3:PutAccountPublicAccessBlock",
            "s3:GetAccountPublicAccessBlock",
            "s3:ListAllMyBuckets",
            "s3:ListAccessPoints",
            "s3:PutAccessPointPublicAccessBlock",
            "s3:ListJobs",
            "s3:PutStorageLensConfiguration",
            "s3:ListMultiRegionAccessPoints",
            "s3:CreateJob"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : "s3:*",
          "Resource" : [
            "arn:aws:s3:::mlflow-sagemaker-eu-central-1-855372857567",
            "arn:aws:s3:::mlflow-sagemaker-eu-central-1-855372857567/*"
          ]
        }
      ]
    }

  )
}


resource "aws_iam_role_policy_attachment" "Sagemaker_full_access_role_policy" {
  role       = aws_iam_role.airflow_service_account_role.name
  policy_arn = data.aws_iam_policy.AmazonSageMakerFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "s3_mlflow_bucket_role_policy" {
  role       = aws_iam_role.airflow_service_account_role.name
  policy_arn = var.s3_mlflow_bucket_policy_arn
}

resource "aws_iam_role_policy_attachment" "s3_default_mlflow_sagemaker_role_policy" {
  role       = aws_iam_role.airflow_service_account_role.name
  policy_arn = aws_iam_policy.default_mlflow_sagemaker_bucket_policy.arn
}
