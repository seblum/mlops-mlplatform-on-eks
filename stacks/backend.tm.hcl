# Generates a backend.tf in every Terramate stack with an isolated state key.
# Run `terramate generate` to materialise.

generate_hcl "backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.terraform.backend_bucket
        key            = "stacks/${terramate.stack.id}/terraform.tfstate"
        region         = global.terraform.backend_region
        dynamodb_table = global.terraform.backend_dynamodb_table
        encrypt        = true
      }
    }
  }
}
