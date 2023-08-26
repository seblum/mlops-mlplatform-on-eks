variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = ""
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster"
  type        = string
  default     = ""
}

variable "create_namespace" {
  description = "Should the namespace be created, if it does not exist?"
  type        = bool
  default     = true
}

variable "helm_chart_version" {
  description = "Version of the Helm chart"
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
  description = "Namespace"
  type        = string
  default     = ""
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = []
}

variable "private_subnets_cidr_blocks" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = []
}

variable "rds_engine" {
  description = "The type of the database engine (postgres, mysql)"
  type        = string
  default     = ""
}

variable "rds_engine_version" {
  description = "The engine version of the database"
  type        = string
  default     = ""
}

variable "rds_instance_class" {
  description = "Database instance type"
  type        = string
  default     = ""
}

variable "rds_max_allocated_storage" {
  description = "The upper limit of scalable storage (Gb)"
  type        = number
  default     = 500
}

variable "rds_name" {
  description = "Database name"
  type        = string
  default     = ""
}

variable "rds_password" {
  description = "Database admin account password"
  type        = string
  default     = null
}

variable "rds_port" {
  description = "Port of the RDS database"
  type        = number
  default     = 0
}

variable "rds_storage_type" {
  description = "Instance storage type: standard, gp2, gp3, or io1"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "Name of the S3 Bucket for the MLFlow artifacts"
  type        = string
  default     = ""
}

variable "s3_force_destroy" {
  description = "Set to true to disable protection against the S3 bucket being destroyed. Use only for dev!"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC of the EKS cluster"
  type        = string
  default     = ""
}
