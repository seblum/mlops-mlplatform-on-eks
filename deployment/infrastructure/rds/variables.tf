variable "vpc_id" {
  description = "VPC of the EKS cluster"
  type        = string
  default     = ""
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = []
}

variable "private_subnets_cidr_blocks" {
  description = "List of private subnet cidr blocks"
  type        = list(string)
  default     = []
}

variable "rds_port" {
  description = "Port of the RDS database"
  type        = number
  default     = 0
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

variable "storage_type" {
  description = "Instance storage type: standard, gp2, gp3, or io1"
  type        = string
  default     = ""
}

variable "max_allocated_storage" {
  description = "The upper limit of scalable storage (GB)"
  type        = number
  default     = 500
}
