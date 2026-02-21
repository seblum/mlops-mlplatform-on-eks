// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  backend "s3" {
    bucket         = "mlplatform-terraform-state"
    dynamodb_table = "mlplatform-terraform-locks"
    encrypt        = true
    key            = "stacks/eks/terraform.tfstate"
    region         = "eu-central-1"
  }
}
