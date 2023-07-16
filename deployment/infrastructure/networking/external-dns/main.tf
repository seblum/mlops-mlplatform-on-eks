locals {
  external_dns_service_account_role_name = "external-dns-role"
  external_dns_service_account_name      = "external-dns-sa"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {} # 


module "external_dns_controller_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.11.1"
  create_role                   = true
  role_name                     = local.external_dns_service_account_role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.external_dns_controller_sa.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${local.external_dns_service_account_name}"]
}

resource "aws_iam_policy" "external_dns_controller_sa" {
  name        = local.external_dns_service_account_name
  description = "EKS ebs-csi-controller policy for cluster ${var.cluster_name}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*" # hostedzoneid
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}


#external-dns helm

resource "helm_release" "external_dns" {
  name             = var.name
  namespace        = "kube-system"
  chart            = var.helm_chart_name
  create_namespace = false

  repository = "https://charts.bitnami.com/bitnami"
  version    = var.helm_chart_version

  values = [yamlencode({
    serviceAccount = {
      create = true
      name   = "${local.external_dns_service_account_name}"
      annotations = {
        "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.external_dns_service_account_role_name}"
      }
    },
    aws = {
      zoneType = "public"
      region   = "${data.aws_region.current.name}"
    },
    policy = "sync"
    domainFilter = [
      "${var.domain_name}"
    ]
    provider   = "aws"
    txtOwnerId = "${var.name}"
  })]
  #  "${file("${path.module}/helm/values.yaml")}"
}

