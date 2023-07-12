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
  type        = string
}

variable "airflow_github_ssh" {
  default = ""
}

variable "max_allocated_storage" {
  type        = number
  description = "The upper limit of scalable storage (Gb)"
  default     = 500
}

variable "git_username" {
  type = string
}

variable "git_token" {
  type = string
}


# AIRFLOW
variable "deploy_airflow" {
  type        = bool
  description = "Should Airflow be deployed?"
  default     = true
}

variable "git_repository_url" {
  type        = string
  description = "Https git url to the Airflow DAG repository"
}

variable "git_branch" {
  type        = string
  description = "Name of the git branch of the Airflow DAG repository"
}

# MLFLOW
variable "deploy_mlflow" {
  type        = bool
  description = "Should MLflow be deployed?"
  default     = true
}
# JUPYTERHUB
variable "deploy_jupyterhub" {
  type        = bool
  description = "Should Jupyterhub be deployed?"
  default     = true
}


# MONITORING

variable "deploy_monitoring" {
  type        = bool
  description = "Should Monitoring be deployed?"
  default     = true
}

