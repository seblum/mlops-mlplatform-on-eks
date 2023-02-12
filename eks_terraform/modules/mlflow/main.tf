
resource "kubernetes_namespace" "namespace-mlflow" {
  metadata {
    name = var.tag_name
  }
}

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
  name  = "mlflow"
  chart = "/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/mlflow/"

  #values = ["eks_terraform/applications/airflow/values.yaml"]
  #   values     = [file("${path.root}/helm/airflow.yml")]
  values = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/mlflow/values.yaml")}"]

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
    name  = "DB_NAME"
    value = module.rds-mlflow.rds_dbname
  }
}
