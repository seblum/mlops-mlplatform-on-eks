# Root Terramate configuration
# Manages IaC orchestration: change detection, code generation, stack ordering.

terramate {
  required_version = ">= 0.10.0"

  config {
    run {
      check_gen_code = true
    }
  }
}

# Shared globals — referenced from stacks/_generate/*.tm.hcl
globals "terraform" {
  backend_bucket         = "mlplatform-terraform-state"
  backend_region         = "eu-central-1"
  backend_dynamodb_table = "mlplatform-terraform-locks"
}

globals "project" {
  name         = "mlplatform"
  region       = "eu-central-1"
  cluster_name = "mlplatform-eks-cluster"
}
