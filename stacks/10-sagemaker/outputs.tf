output "sagemaker_access_role_name" {
  value = module.sagemaker.sagemaker_access_role_name
}

output "ecr_repository_name" {
  value = module.sagemaker.ecr_repository_name
}

output "ecr_sagemaker_image_tag" {
  value = module.sagemaker.repository_model_tag
}
