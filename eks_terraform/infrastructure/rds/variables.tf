
variable "vpc_private_subnets" {
  default = ""
}
variable "private_subnets_cidr_blocks" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "rds_port" {
  default = ""
}
variable "rds_name" {
  type    = string
  default = ""
}

variable "rds_engine" {
  type    = string
  default = ""
}

variable "rds_engine_version" {
  type    = string
  default = ""
}

variable "storage_type" {
  type        = string
  description = "Instance storage type: standard, gp2, gp3, or io1"
  default     = ""
}

variable "max_allocated_storage" {
  type        = number
  description = "The upper limit of scalable storage (Gb)"
  default     = 500
}

variable "parameter_group_name" {
  type = string
}

variable "rds_instance_class" {

}


variable "rds_password" {

}
