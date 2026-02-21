# Generates providers.tf per stack. Terraform only allows ONE required_providers
# block per root module, so we must emit a complete providers.tf for each case.
#
# Conditions are mutually exclusive:
#   "infra"-only stacks  → AWS + random + null providers
#   "app"-tagged stacks  → all of the above + Helm + Kubernetes (with EKS data sources)
#
# Run `terramate generate` to materialise.

# ── Infra-only stacks (no "app" tag) ─────────────────────────────────────────
generate_hcl "providers.tf" {
  condition = !tm_contains(terramate.stack.tags, "app")

  content {
    terraform {
      required_version = ">= 1.10.0"

      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 6.0"
        }
        random = {
          source  = "hashicorp/random"
          version = "~> 3.6"
        }
        null = {
          source  = "hashicorp/null"
          version = "~> 3.2"
        }
      }
    }

    provider "aws" {
      region = global.project.region
    }
  }
}

# ── App stacks (tagged "app") — full provider set incl. Helm + Kubernetes ────
generate_hcl "providers.tf" {
  condition = tm_contains(terramate.stack.tags, "app")

  content {
    terraform {
      required_version = ">= 1.10.0"

      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 6.0"
        }
        random = {
          source  = "hashicorp/random"
          version = "~> 3.6"
        }
        null = {
          source  = "hashicorp/null"
          version = "~> 3.2"
        }
        helm = {
          source  = "hashicorp/helm"
          version = "~> 2.17"
        }
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = "~> 2.35"
        }
      }
    }

    provider "aws" {
      region = global.project.region
    }

    # Read cluster details at provider init time using AWS data sources.
    # Avoids hard-coding a kubeconfig or cluster certificate.
    data "aws_eks_cluster" "main" {
      name = global.project.cluster_name
    }

    data "aws_eks_cluster_auth" "main" {
      name = global.project.cluster_name
    }

    provider "kubernetes" {
      host                   = data.aws_eks_cluster.main.endpoint
      cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
      token                  = data.aws_eks_cluster_auth.main.token
    }

    provider "helm" {
      kubernetes {
        host                   = data.aws_eks_cluster.main.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
        token                  = data.aws_eks_cluster_auth.main.token
      }
    }
  }
}
