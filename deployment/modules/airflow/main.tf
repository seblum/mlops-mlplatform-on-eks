locals {
  prefix                       = "${var.name_prefix}-${var.namespace}"
  k8s_airflow_db_secret_name   = "${local.prefix}-db-auth"
  git_airflow_repo_secret_name = "${local.prefix}-https-git-secret"
  git_organization_secret_name = "${local.prefix}-organization-git-secret"
  s3_data_bucket_secret_name   = "${var.namespace}-${var.s3_data_bucket_secret_name}"
  s3_data_bucket_name          = "${local.prefix}-${var.s3_data_bucket_name}"

  airflow_variable_list_addition = [
    {
      key   = "s3_access_name"
      value = "${local.s3_data_bucket_secret_name}"
    }
  ]
  airflow_variable_list_full = concat(var.airflow_variable_list, local.airflow_variable_list_addition)
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {} #

resource "kubernetes_namespace" "airflow" {
  metadata {

    name = var.namespace
  }
}

################################################################################
#
# IAM Service Account Roles and Policies
#
module "iam-service-account" {
  source             = "./iam_service_account"
  namespace          = var.namespace
  oidc_provider_arn  = var.oidc_provider_arn
  s3_mlflow_bucket_policy_arn = var.s3_mlflow_bucket_policy_arn
}

################################################################################
#
# Data Storage
#
module "s3-data-storage" {
  source                      = "./data_storage"
  namespace                   = var.namespace
  s3_data_bucket_name         = local.s3_data_bucket_name
  s3_data_bucket_secret_name  = local.s3_data_bucket_secret_name
  s3_force_destroy            = true
}

################################################################################
#
# Helm Release Airflow
#
resource "kubernetes_secret" "airflow_db_credentials" {
  metadata {
    name      = local.k8s_airflow_db_secret_name
    namespace = helm_release.airflow.namespace
  }
  data = {
    "postgresql-password" = module.rds-airflow.rds_password
  }
}

resource "kubernetes_secret" "airflow_https_git_secret" {
  metadata {
    name      = local.git_airflow_repo_secret_name
    namespace = helm_release.airflow.namespace
  }
  data = {
    "username" = var.git_username
    "password" = var.git_token
  }
}

resource "kubernetes_secret" "airflow_organization_git_secret" {
  metadata {
    name      = local.git_organization_secret_name
    namespace = helm_release.airflow.namespace
  }
  data = {
    "GITHUB_CLIENT_ID"     = var.git_client_id
    "GITHUB_CLIENT_SECRET" = var.git_client_secret
  }
}


# secret with account information
resource "kubernetes_secret" "aws-account-information" {
  metadata {
    name      = "${var.namespace}-aws-account-information"
    namespace = var.namespace
  }
  data = {
    "AWS_REGION" = "${data.aws_region.current.name}"
    "AWS_ID"     = "${data.aws_caller_identity.current.account_id}"
  }
}

# secret for sagemaker
resource "kubernetes_secret" "sagemaker-access" {
  metadata {
    name      = "${var.namespace}-sagemaker-access"
    namespace = var.namespace
  }
  data = {
    "AWS_ROLE_NAME_SAGEMAKER" = var.sagemaker_access_role_name # TODO "${var.sagemaker_access_role_arn}"
  }
}

# RDS
resource "random_password" "rds_password" {
  length  = 16
  special = false
}

module "rds-airflow" {
  source                      = "../../infrastructure/rds"
  vpc_id                      = var.vpc_id
  private_subnets             = var.private_subnets
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  rds_port                    = var.rds_port
  rds_name                    = var.rds_name
  rds_password                = coalesce(var.rds_password, random_password.rds_password.result)
  rds_engine                  = var.rds_engine
  rds_engine_version          = var.rds_engine_version
  rds_instance_class          = var.rds_instance_class
  storage_type                = var.rds_storage_type
  max_allocated_storage       = var.rds_max_allocated_storage
}

# HELM
resource "helm_release" "airflow" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace

  repository = "https://airflow-helm.github.io/charts"
  chart      = var.helm_chart_name
  version    = var.helm_chart_version
  wait       = false # deactivate post install hooks otherwise will fail

  values = [yamlencode({
    airflow = {
      extraEnv = [
        {
          name = "GITHUB_CLIENT_ID"
          valueFrom = {
            secretKeyRef = {
              name = local.git_organization_secret_name
              key  = "GITHUB_CLIENT_ID"
            }
          }
        },
        {
          name = "GITHUB_CLIENT_SECRET"
          valueFrom = {
            secretKeyRef = {
              name = local.git_organization_secret_name
              key  = "GITHUB_CLIENT_SECRET"
            }
          }
        }
      ],
      config = {
        AIRFLOW__WEBSERVER__EXPOSE_CONFIG = false
        AIRFLOW__WEBSERVER__BASE_URL      = "http://${var.domain_name}/${var.domain_suffix}"

        AIRFLOW__CORE__LOAD_EXAMPLES = false
        # AIRFLOW__LOGGING__LOGGING_LEVEL          = "DEBUG"
        # AIRFLOW__LOGGING__REMOTE_LOGGING         = true
        # AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER = "s3://${module.s3-data-storage.s3_log_bucket_name}/airflow/logs"
        # AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID     = "aws_logs_storage_access"
        AIRFLOW__CORE__DEFAULT_TIMEZONE = "Europe/Amsterdam"
      },
      users = []
      image = {
        repository = "seblum/airflow"
        tag        = "2.6.3-python3.11-custom-light"
        pullPolicy = "IfNotPresent"
        pullSecret = ""
        uid        = 50000
        gid        = 0
      },
      executor           = "KubernetesExecutor"
      fernetKey          = var.fernet_key
      webserverSecretKey = "THIS IS UNSAFE!"
      # connections = [
      #   {
      #     id          = "aws_logs_storage_access"
      #     type        = "aws"
      #     description = "AWS connection to store logs on S3"
      #     extra       = "{\"region_name\": \"${data.aws_region.current.name}\"}"
      #   }
      # ],
      variables = local.airflow_variable_list_full
    },
    serviceAccount = {
      create = true
      name   = "airflow-sa"
      annotations = {
        "eks.amazonaws.com/role-arn" = "${module.iam-service-account.airflow_service_account_role_arn}"
      }
    },
    scheduler = {
      logCleanup = {
        enabled = false
      }
    },
    workers = {
      enabled = false
      logCleanup = {
        enables = true
      }
    },
    flower = {
      enabled = false
    },
    postgresql = {
      enabled = false
    },
    redis = {
      enabled = false
    },
    externalDatabase = {
      type              = "postgres"
      host              = module.rds-airflow.rds_host
      port              = var.rds_port
      database          = "airflow_db"
      user              = "airflow_admin"
      passwordSecret    = local.k8s_airflow_db_secret_name
      passwordSecretKey = "postgresql-password"
    },
    dags = {
      path = "/opt/airflow/dags"
      gitSync = {
        enabled  = true
        repo     = var.git_repository_url
        branch   = var.git_branch
        revision = "HEAD"
        # repoSubPath           = "workflows"
        httpSecret            = local.git_airflow_repo_secret_name
        httpSecretUsernameKey = "username"
        httpSecretPasswordKey = "password"
        syncWait              = 60
        syncTimeout           = 120
      }
    },
    logs = {
      path = "/opt/airflow/logs"
      persistence = {
        enabled = true
        storageClass : "efs"
        size : "5Gi"
        accessMode : "ReadWriteMany"
      }
    },
    ingress = {
      enabled    = true
      apiVersion = "networking.k8s.io/v1"
      web = {
        annotations = {
          "external-dns.alpha.kubernetes.io/hostname"  = "${var.domain_name}"
          "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
          "alb.ingress.kubernetes.io/target-type"      = "ip"
          "kubernetes.io/ingress.class"                = "alb"
          "alb.ingress.kubernetes.io/group.name"       = "mlplatform"
          "alb.ingress.kubernetes.io/healthcheck-path" = "/${var.domain_suffix}/health"
        }
        path = "/${var.domain_suffix}"
        host = "${var.domain_name}"
        precedingPaths = [{
          path        = "/${var.domain_suffix}*"
          serviceName = "airflow-web"
          servicePort = "web"
        }]
      }
    },
    web = {
      readinessProbe = {
        enabled             = true
        initialDelaySeconds = 45
      },
      livenessProbe = {
        enabled             = true
        initialDelaySeconds = 45
      },
      webserverConfig = {
        stringOverride = file("${path.module}/WebServerConfig.py")
      }
    },
  })]
}
