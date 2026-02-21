stack {
  name        = "sagemaker"
  description = "ECR repository and SageMaker dashboard Helm release."
  id          = "sagemaker"
  tags        = ["app", "mlops"]

  after = [
    "../networking",
  ]
}
