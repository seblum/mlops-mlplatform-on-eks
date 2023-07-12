
variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "name_prefix" {
  type = string
}
variable "create_namespace" {
  type        = bool
  description = "Should the namespace be created, if it does not exists?"
  default     = true
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS Cluster"
}

variable "cluster_endpoint" {
  type        = string
  description = "Endpoint of the EKS Cluster"
}

variable "oidc_provider_arn" {
  type        = string
  description = "arn of the OIDC provider"
}

variable "user_profiles" {
  type        = list(any)
  description = "list of user profiles"
  default = [
    {
      "username" = "user"
      "password" = "user123"
      "role" = [
        "User",
        "Viewer"
      ]
      "email"     = "user@example.com"
      "firstName" = "user"
      "lastName"  = "user"
  }]
}

variable "s3_data_bucket_secret_name" {

}

variable "s3_data_bucket_name" {

}

# RDS

variable "vpc_id" {
  type        = string
  description = "VPC of the EKS cluster"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "List of private subnet cidr blocks"
}

variable "rds_port" {
  type        = number
  description = "Port of the rds database"
}

variable "rds_name" {
  type        = string
  description = "Database name"
}

variable "rds_password" {
  type        = string
  description = "Database admin account password"
  default     = null
}

variable "rds_engine" {
  type        = string
  description = "The type of the database engine (postgres, mysql)"
}

variable "rds_engine_version" {
  type        = string
  description = "The engine version of the database"
}

variable "rds_instance_class" {
  type        = string
  description = "Database instance type"
}

variable "storage_type" {
  type        = string
  description = "Instance storage type: standard, gp2, gp3, or io1"
}

variable "max_allocated_storage" {
  type        = number
  description = "The upper limit of scalable storage (Gb)"
  default     = 500
}


# HELM

variable "helm_chart_repository" {
  type        = string
  description = "Repository URL or path to the location of the helm repo"
}

variable "helm_chart_name" {
  type        = string
  description = "Name of the helm chart"
}

variable "helm_chart_version" {
  type        = string
  description = "Version of the helm chart"
}

variable "git_username" {
  type        = string
  description = "Username to access Github"
}

variable "git_token" {
  type        = string
  description = "Github token"
}

variable "git_repository_url" {
  type        = string
  description = "Https URL to the Github repository to sync Airflow with"
}

variable "git_branch" {
  type        = string
  description = "Branch of the Github repository"
}

variable "mlflow_tracking_uri" {
  type        = string
  description = "The internal address of MLflow, to make it easily accessible from Jupyter."
}

variable "s3_force_destroy" {
  type        = bool
  description = "Set to true to disable protection against s3 bucket being destroyed. Use only for dev!"
  default     = false
}





# Test


# variable "plugins" { default = [
#   {
#     username  = "user",
#     password  = "user123",
#     role      = "User",
#     email     = "user@example.com",
#     firstName = "user",
#     lastName  = "user"
#   }
# ] }
