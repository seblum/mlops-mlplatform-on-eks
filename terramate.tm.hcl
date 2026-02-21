# Root Terramate configuration
# Manages IaC orchestration: change detection, code generation, stack ordering

terramate {
  required_version = ">= 0.10.0"

  config {
    # Run stacks in the order defined by `after` constraints
    run {
      check_gen_code = true
    }
  }
}

# Global values shared across all stacks via code generation
globals "terraform" {
  backend_bucket         = "mlplatform-terraform-state"
  backend_region         = "eu-central-1"
  backend_dynamodb_table = "mlplatform-terraform-locks"
}

globals "project" {
  name   = "mlplatform"
  region = "eu-central-1"
}
