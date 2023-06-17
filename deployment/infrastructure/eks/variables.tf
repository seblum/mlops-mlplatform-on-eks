variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS Cluster"
}

variable "eks_cluster_version" {
  type        = string
  description = "Version number of the EKS Cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC of the EKS cluster"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
}

variable "security_group_id_one" {
  type        = list(string)
  description = "ID of EKS worker security group one"
}

variable "security_group_id_two" {
  type        = list(string)
  description = "ID of EKS worker security group two"
}
