locals {
  s3_data_bucket_user_name = "airflow-s3-data-bucket-user"
}
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "s3_data_storage" {
  bucket        = var.s3_data_bucket_name
  force_destroy = var.s3_force_destroy
}

resource "aws_iam_user" "s3_data_bucket_user" {
  name = local.s3_data_bucket_user_name
  path = "/"
}

resource "aws_iam_access_key" "s3_data_bucket_credentials" {
  user = aws_iam_user.s3_data_bucket_user.name
}

# Airflow user needs to have access to mlflow policy. MLflow policy is passed through
resource "aws_iam_user_policy_attachment" "s3_data_bucket_user_mlflow_policy" {
  # count      = var.s3_mlflow_bucket_policy_arn != "not-deployed" ? 1 : 0
  user       = aws_iam_user.s3_data_bucket_user.name
  policy_arn = var.s3_mlflow_bucket_policy_arn
}

resource "aws_iam_policy" "s3_data_bucket_policy" {
  name = "${var.namespace}-s3-data-bucket-policy"
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
          "arn:aws:s3:::${aws_s3_bucket.s3_data_storage.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.s3_data_storage.bucket}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListBucketVersions"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.s3_data_storage.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.s3_data_storage.bucket}"
        ],
      }
  ] })
}

resource "aws_iam_role" "s3_data_bucket_role" {
  name                 = "${var.namespace}-s3-data-bucket-role"
  max_session_duration = 28800

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.s3_data_bucket_user.name}"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
              "Service": "s3.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "s3_data_bucket_role_policy" {
  role       = aws_iam_role.s3_data_bucket_role.name
  policy_arn = aws_iam_policy.s3_data_bucket_policy.arn
}

resource "kubernetes_secret" "s3_data_bucket_access_credentials" {
  metadata {
    name      = var.s3_data_bucket_secret_name
    namespace = var.namespace
  }
  data = {
    "AWS_BUCKET"            = "${aws_s3_bucket.s3_data_storage.bucket}"
    "AWS_ACCESS_KEY_ID"     = "${aws_iam_access_key.s3_data_bucket_credentials.id}"
    "AWS_SECRET_ACCESS_KEY" = "${aws_iam_access_key.s3_data_bucket_credentials.secret}"
    "AWS_ROLE_NAME"         = "${aws_iam_role.s3_data_bucket_role.name}"
  }
}
