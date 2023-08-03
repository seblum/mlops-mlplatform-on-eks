locals {
  aws_load_balancer_controller_service_account_role_name = "aws-load-balancer-controller-role"
  aws_load_balancer_controller_service_account_name      = "aws-load-balancer-controller-sa"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {} # 

module "aws_load_balancer_controller_controller_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.11.1"
  create_role                   = true
  role_name                     = local.aws_load_balancer_controller_service_account_role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.aws_load_balancer_controller_controller_sa.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:${local.aws_load_balancer_controller_service_account_name}"]
}

resource "aws_iam_policy" "aws_load_balancer_controller_controller_sa" {
  name        = local.aws_load_balancer_controller_service_account_name
  description = "EKS ebs-csi-controller policy for cluster ${var.cluster_name}"

  policy = file("${path.module}/AWSLoadBalancerControllerPolicy.json")
}

resource "helm_release" "aws-load-balancer-controller" {
  name             = var.helm_chart_name
  namespace        = var.namespace
  chart            = "aws-load-balancer-controller"
  create_namespace = false

  repository = "https://aws.github.io/eks-charts"
  version    = var.helm_chart_version

  values = [yamlencode({
    clusterName = var.cluster_name
    image = {
      tag = "v2.4.2"
    },
    serviceAccount = {
      name = "${local.aws_load_balancer_controller_service_account_name}"
      annotations = {
        "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.aws_load_balancer_controller_service_account_role_name}"
      }
    }
  })]
}
