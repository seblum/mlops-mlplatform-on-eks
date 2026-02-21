stack {
  name        = "10-sagemaker"
  description = "ECR repository for MLflow SageMaker images and SageMaker dashboard Helm release."
  id          = "sagemaker"
  tags        = ["app"]

  after = ["../03-networking"]
}
