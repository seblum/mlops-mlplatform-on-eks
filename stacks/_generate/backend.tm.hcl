# Terramate code-generation for per-stack backend configuration.
# Place this file in a parent directory of all stacks (or the root) so every
# stack gets its own state file key derived from its stack ID.
#
# Run `terramate generate` to materialise the generated files.

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
