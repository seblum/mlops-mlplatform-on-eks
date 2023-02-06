variable "AWS_ACCESS_KEY" {
  default     = ""
  description = "AWS access key id"
}

variable "AWS_SECRET_KEY" {
  default     = ""
  description = "AWS secret access key"
}

variable "aws_region" {
  default     = "eu-central-1"
  description = "AWS region"
}

variable "AIRFLOW_GITHUB_SSH" {
  default = ""
}

variable "cluster_name" {
  default = "airflow-seblum-eks"
}

variable "vpc_name" {
  default = "airflow-seblum-vpc"
}

variable "port_airflow" {
  default = ""
}

variable "port_mlflow" {
  default = ""
}
