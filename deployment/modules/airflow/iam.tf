resource "aws_iam_user" "this" {
  name = "airflow-log-s3-user"
  path = "/"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}


resource "kubernetes_secret" "this" {
  metadata {
    name      = "airflow-log-user-cred"
    namespace = "airflow"
  }
  data = {
    "ACCESS_KEY_ID" : aws_iam_access_key.this.id,
    "SECRET_ACCESS_KEY" : aws_iam_access_key.this.secret
  }
}



resource "aws_iam_policy" "logging_s3_access" {
  name = "s3-bucket-access-airflow-log-s3-user"
  path = "/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowKFPtoWriteLogsAndArtifacts",
        "Effect" : "Allow",
        "Action" : [
          "s3:*Object",
          "s3:GetObjectVersion"
        ],
        "Resource" : [
          "arn:aws:s3:::airflow-bucket-logs/logs/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListBucketVersions"
        ],
        "Resource" : [
          "arn:aws:s3:::airflow-bucket-logs/logs/*"
        ],
      }
  ] })
}


resource "aws_iam_user_policy_attachment" "s3_bucket_access" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.logging_s3_access.arn
}
