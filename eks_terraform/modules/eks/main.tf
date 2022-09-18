
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.20"
  subnets         = var.private_subnets

  vpc_id = var.vpc_id

  cluster_endpoint_public_access = true

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = var.security_group_id_one
      asg_desired_capacity          = 2
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = var.security_group_id_two
      asg_desired_capacity          = 1
    },
  ]
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

### ------------ ###
###  KUBERNETES  ###
### ------------ ###

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "namespace-monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "namespace-airflow" {
  metadata {
    name = "airflow"
  }
}

resource "kubernetes_namespace" "namespace-mlflow" {
  metadata {
    name = "mlflow"
  }
}


resource "kubernetes_secret" "airflow_db_credentials" {
  metadata {
    name      = "airflow-db-auth"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }
  data = {
    "postgresql-password" = var.rds_password
  }
}

resource "kubernetes_secret" "airflow_git_ssh_secret" {
  metadata {
    name      = "airflow-git-ssh-secret"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }
  data = {
    "gitSshKey" = var.github_ssh
    # "${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/ssh/airflow_dag")}"
    #"known_hosts" = "${file("/Users/sebastian.blum/.ssh/known_hosts")}"
    #"id_ed25519.pub" = "${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/ssh/airflow_dag.pub")}"
  }
}
