variable "domain_name" {
  type    = string
  default = ""
}

module "sagemaker" {
  source        = "../../components/sagemaker"
  name          = "sagemaker-dashboard"
  namespace     = "sagemaker-dashboard"
  domain_name   = var.domain_name
  domain_suffix = "/sagemaker"

  docker_mlflow_sagemaker_base_image = "seblum/mlflow-sagemaker-deployment:v2.3.2"
}
