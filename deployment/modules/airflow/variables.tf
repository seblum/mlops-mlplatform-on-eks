variable "airflow_variable_list" {
  description = "List of Airflow variables to be set"
  type        = list(any)
  default = [{
    "key"   = "MLFLOW_TRACKING_URI"
    "value" = "http://mlflow-service.mlflow.svc.cluster.local"
  }]
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS Cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "create_namespace" {
  description = "Should the namespace be created, if it does not exist?"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = ""
}

variable "domain_suffix" {
  description = "Domain suffix"
  type        = string
  default     = ""
}

variable "fernet_key" {
  type        = string
  description = "Fernet key"
}

variable "git_branch" {
  description = "Branch of the Github repository"
  type        = string
}

variable "git_client_id" {
  description = "Client ID for Git integration"
  type        = string
  default     = ""
}

variable "git_client_secret" {
  description = "Client secret for Git integration"
  type        = string
  default     = ""
}

variable "git_repository_url" {
  description = "Https URL to the Github repository to sync Airflow with"
  type        = string
  default     = ""
}

variable "git_token" {
  description = "GitHub token"
  type        = string
}

variable "git_username" {
  description = "Username for Git authentication"
  type        = string
  default     = ""
}

variable "helm_chart_name" {
  description = "Name of the helm chart"
  type        = string
  default     = ""
}

variable "helm_chart_repository" {
  description = "Repository URL or path to the location of the helm repo"
  type        = string
  default     = ""
}

variable "helm_chart_version" {
  description = "Version of the helm chart"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name"
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "Name prefix"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Namespace to launch Prometheus & Grafana"
  type        = string
  default     = "monitoring"
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "private_subnets_cidr_blocks" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "rds_engine" {
  description = "The type of the database engine (postgres, mysql)"
  type        = string
}

variable "rds_engine_version" {
  description = "The engine version of the database"
  type        = string
}

variable "rds_instance_class" {
  description = "Database instance type"
  type        = string
}

variable "rds_max_allocated_storage" {
  description = "The upper limit of scalable storage (Gb)"
  type        = number
  default     = 500
}

variable "rds_name" {
  description = "Database name"
  type        = string
}

variable "rds_password" {
  description = "Database admin account password"
  type        = string
  default     = null
}

variable "rds_port" {
  description = "Port of the RDS database"
  type        = number
}

variable "rds_storage_type" {
  description = "Instance storage type: standard, gp2, gp3, or io1"
  type        = string
}

variable "s3_data_bucket_name" {
  description = "Name of the S3 data bucket"
  type        = string
}

variable "s3_data_bucket_secret_name" {
  description = "Name of the secret for the S3 data bucket"
  type        = string
}

variable "s3_force_destroy" {
  description = "Set to true to disable protection against S3 bucket being destroyed. Use only for dev!"
  type        = bool
  default     = false
}

variable "s3_data_bucket_user_name" {
  description = "User name for S3 data bucket"
  type        = string
}

variable "vpc_id" {
  description = "VPC of the EKS cluster"
  type        = string
}