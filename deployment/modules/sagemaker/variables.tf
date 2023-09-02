variable "create_namespace" {
  description = "Should the namespace be created if it does not exist?"
  type        = bool
  default     = true
}

variable "docker_mlflow_sagemaker_base_image" {
  description = "Name:Tag of the DockerHub repository that has a mlflow sagemaker base image"
  type        = string
  default     = ""
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

variable "name" {
  description = "Name"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Namespace"
  type        = string
  default     = ""
}

# variable "s3_mlflow_bucket_policy_arn" {
#   description = "Policy arn to access an additional externally create s3 bucket"
#   type        = string
#   default     = ""
# }
