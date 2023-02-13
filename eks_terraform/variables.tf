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

variable "airflow_github_ssh" {
  default = ""
}

variable "name_prefix" {
  default = "airflow-seblum"
}

variable "max_allocated_storage" {
  type        = number
  description = "The upper limit of scalable storage (Gb)"
  default     = 500
}

variable "port_mlflow" {
}

variable "port_airflow" {

}

variable "git_username" {

}

variable "git_token" {

}
