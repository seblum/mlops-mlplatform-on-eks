SHELL := /bin/bash # Use bash syntax
VARS_FILE ?= testing.tfvars

apply: init \
	apply-all

init:
	terraform init

fmt:
	terraform fmt -recursive .

wipe-tf-state:
	terraform state rm $$(terraform state list)

# FULL DEPLOYMENT
deploy-all: init \
	create-vpc \
	create-eks-cluster \
	deploy-modules

destroy-all: init \
	destroy-modules \
	destroy-eks-cluster \
	# TODO: delete loadbalancer and zielgruppen - currently done manually
	destroy-vpc


# TERRAFORM APPLY
create-vpc:
	terraform apply	-target="module.vpc" -var-file=$(VARS_FILE) -auto-approve

create-eks-cluster:
	terraform apply	-target="module.user-profiles" \
					-target="module.eks" \
					-target="module.networking" \
					-var-file=$(VARS_FILE) -auto-approve

# MODULES
deploy-airflow:
	terraform apply -target="module.airflow" -var-file=$(VARS_FILE) -auto-approve

deploy-dashboard:
	terraform apply -target="module.dashboard" -var-file=$(VARS_FILE) -auto-approve

deploy-jupyterhub:
	terraform apply -target="module.jupyterhub" -var-file=$(VARS_FILE) -auto-approve

deploy-mlflow:
	terraform apply -target="module.mlflow" -var-file=$(VARS_FILE) -auto-approve

deploy-monitoring:
	terraform apply -target="module.monitoring" -var-file=$(VARS_FILE) -auto-approve

deploy-sagemaker:
	terraform apply -target="module.sagemaker" -var-file=$(VARS_FILE) -auto-approve

deploy-modules:
	terraform apply -target="module.airflow" \
					-target="module.dashboard" \
					-target="module.jupyterhub" \
					-target="module.mlflow" \
					-target="module.monitoring" \
					-target="module.sagemaker" \
					-var-file=$(VARS_FILE) -auto-approve

apply-all:
	terraform apply -var-file=$(VARS_FILE) -auto-approve

# TERRAFORM DESTROY
destroy-vpc:
	terraform destroy -target="module.vpc" -var-file=$(VARS_FILE) -auto-approve

destroy-eks-cluster:
	terraform destroy   -target="module.networking" \
						-target="module.eks" \
						-target="module.user-profiles" \
						-var-file=$(VARS_FILE) -auto-approve

# MODULES
destroy-airflow:
	terraform destroy -target="module.airflow" -var-file=$(VARS_FILE) -auto-approve

destroy-mlflow:
	terraform destroy -target="module.mlflow" -var-file=$(VARS_FILE) -auto-approve

destroy-jupyterhub:
	terraform destroy -target="module.jupyterhub" -var-file=$(VARS_FILE) -auto-approve

destroy-monitoring:
	terraform destroy -target="module.monitoring" -var-file=$(VARS_FILE) -auto-approve

destroy-sagemaker:
	terraform destroy -target="module.sagemaker" -var-file=$(VARS_FILE) -auto-approve

destroy-user-profiles:
	terraform destroy -target="module.user-profiles" -var-file=$(VARS_FILE) -auto-approve

destroy-modules:
	terraform destroy -target="module.airflow" \
					-target="module.dashboard" \
					-target="module.jupyterhub" \
					-target="module.mlflow" \
					-target="module.monitoring" \
					-target="module.sagemaker" \
					-var-file=$(VARS_FILE) -auto-approve

# don't create executables
.PHONY: *
