output "ecr_repository_name" {
  description = "ECR repository name with mlflow sagemaker deployment image"
  value       = local.ecr_repository_name
}

output "sagemaker_access_role_arn" {
  description = "Access role arn that enables Sagemaker access"
  value       = aws_iam_role.sagemaker_access_role.arn
}