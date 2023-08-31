variable "aws_auth_users_list" {
  description = "List of aws auth users of the EKS cluster"
  type        = list(any)
  default = [
    {
      userarn  = "arn:aws:iam::CURRENT_ACCOUNT_ID:user/USER_NAME"
      username = "USER_NAME"
      groups   = ["system:masters"]
    }
  ]
}

variable "azs" {
  description = "Availability zones"
  type        = list(any)
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
