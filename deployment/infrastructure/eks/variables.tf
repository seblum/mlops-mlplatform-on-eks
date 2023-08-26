variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = [""]
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = ""
}

variable "eks_cluster_version" {
  description = "Version number of the EKS Cluster"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC of the EKS cluster"
  type        = string
  default     = ""
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = [""]
}

variable "private_subnets_cidr_blocks" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = [""]
}

variable "security_group_id_one" {
  description = "ID of EKS worker security group one"
  type        = list(string)
  default     = [""]
}

variable "security_group_id_two" {
  description = "ID of EKS worker security group two"
  type        = list(string)
  default     = [""]
}
