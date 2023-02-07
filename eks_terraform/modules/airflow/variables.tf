variable "github_ssh" {}
variable "rds_password" {}

variable "vpc_id" {}
variable "private_subnets" {}
variable "private_subnets_cidr_blocks" {}
variable "rds_port" {}
variable "rds_name" {}
variable "rds_engine" {}
variable "rds_engine_version" {}

variable "tag_name" {}
variable "cluster_name" {}
variable "cluster_endpoint" {}
variable "eks_cluster_authority" {}

variable "helm_chart_repository" {}
variable "helm_chart_name" {}
variable "helm_chart_version" {}

variable "storage_type" {
  type        = string
  description = "Instance storage type: standard, gp2, gp3, or io1"
}

variable "max_allocated_storage" {
  type        = number
  description = "The upper limit of scalable storage (Gb)"
  default     = 500
}
