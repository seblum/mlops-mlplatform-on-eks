data "aws_caller_identity" "current" {}
data "aws_region" "current" {} # 

resource "aws_s3_bucket" "s3_log_storage" {
  bucket        = var.s3_log_bucket_name
  force_destroy = var.s3_force_destroy
}

resource "aws_iam_role" "s3_log_bucket_role" {
  name                 = "${var.namespace}-s3-log-bucket-access-role"
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

resource "aws_iam_policy" "s3_log_bucket_policy" {
  name = "${var.namespace}-s3-log-bucket-access-policy"
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
          "arn:aws:s3:::${aws_s3_bucket.s3_log_storage.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.s3_log_storage.bucket}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListBucketVersions"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.s3_log_storage.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.s3_log_storage.bucket}"
        ],
      }
  ] })
}

resource "aws_iam_role_policy_attachment" "s3_log_bucket_role_policy" {
  role       = aws_iam_role.s3_log_bucket_role.name
  policy_arn = aws_iam_policy.s3_log_bucket_policy.arn
}


