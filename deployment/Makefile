SHELL := /bin/bash # Use bash syntax
VARS_FILE ?= testing.tfvars

apply: init \
	apply-all

deploy-all: init \
	create-vpc \
	create-eks-cluster \
	deploy-airflow \
	deploy-mlflow \
	deploy-jupyterhub


destroy-all: init \
	destroy-mlflow \
	destroy-jupyterhub \
	destroy-airflow \
	destroy-eks-cluster \
	destroy-vpc \

init:
	terraform init

fmt:
	terraform fmt -recursive .

# TERRAFORM APPLY
create-vpc:
	terraform apply	-target="module.vpc" -var-file=$(VARS_FILE) -auto-approve

create-eks-cluster:
	terraform apply	-target="module.eks" -var-file=$(VARS_FILE) -auto-approve

deploy-airflow:
	terraform apply -target="module.airflow" -var-file=$(VARS_FILE) -auto-approve

deploy-mlflow:
	terraform apply -target="module.mlflow" -var-file=$(VARS_FILE) -auto-approve

deploy-jupyterhub:
	terraform apply -target="module.jupyterhub" -var-file=$(VARS_FILE) -auto-approve

apply-all:
	terraform apply -var-file=$(VARS_FILE) -auto-approve

# TERRAFORM DESTROY
destroy-vpc:
	terraform destroy -target="module.vpc" -var-file=$(VARS_FILE) -auto-approve

destroy-eks-cluster:
	terraform destroy -target="module.eks" -var-file=$(VARS_FILE) -auto-approve

destroy-networking:
	terraform destroy -target="module.networking" -var-file=$(VARS_FILE) -auto-approve

destroy-airflow:
	terraform destroy -target="module.airflow" -var-file=$(VARS_FILE) -auto-approve

destroy-mlflow:
	terraform destroy -target="module.mlflow" -var-file=$(VARS_FILE) -auto-approve

destroy-jupyterhub:
	terraform destroy -target="module.jupyterhub" -var-file=$(VARS_FILE) -auto-approve

destroy-monitoring:
	terraform destroy -target="module.monitoring" -var-file=$(VARS_FILE) -auto-approve

destroy-user-profiles:
	terraform destroy -target="module.user-profiles" -var-file=$(VARS_FILE) -auto-approve

destroy-modules:
	terraform destroy -target="module.monitoring" \ 
					-target="module.jupyterhub" \
					-target="module.mlflow" \
					-target="module.airflow" \
					-target="module.user-profiles" \
					-var-file=$(VARS_FILE) -auto-approve

destroy-test:
	terraform destroy \
					-target="module.mlflow" \
					-target="module.airflow" \
					-target="module.user-profiles" \
					-target="module.eks" \
					-var-file=$(VARS_FILE) -auto-approve

# wipe-tf-state:
# 	terraform state rm $$(terraform state list)

# don't create executables
.PHONY: *
