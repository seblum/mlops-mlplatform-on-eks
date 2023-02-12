SHELL := /bin/bash # Use bash syntax
VARS_FILE ?= testing.tfvars

deploy: init \
	create-vpc \
	create-eks-cluster \
	deploy-coder \
	#deploy-airflow \
	#deploy-mlflow


destroy: init \
	destroy-mlflow
	destroy-airflow \
	destroy-coder \
	destroy-eks-cluster \
	destroy-vpc \

# $(eval AWS_CALLER_ID:=$(shell aws sts get-caller-identity | jq -r ".Account"))
# 		-backend-config="bucket=$(AWS_CALLER_ID)-terraform-states" \
#    	-backend-config="dynamodb_table=$(AWS_CALLER_ID)-terraform-states-lock"
init:
	terraform init

# TERRAFORM APPLY
create-vpc:
	terraform apply	-target="module.vpc" -var-file=$(VARS_FILE) -auto-approve

create-eks-cluster:
	terraform apply	-target="module.eks" -var-file=$(VARS_FILE) -auto-approve

deploy-airflow:
	terraform apply -target="module.airflow" -var-file=$(VARS_FILE) -auto-approve

deploy-mlflow:
	terraform apply -target="module.mlflow" -var-file=$(VARS_FILE) -auto-approve

deploy-coder:
	terraform apply -target="module.coder" -var-file=$(VARS_FILE) -auto-approve

# TERRAFORM DESTRY
destroy-vpc:
	terraform destroy	-target="module.vpc" -var-file=$(VARS_FILE) -auto-approve

destroy-eks-cluster:
	terraform destroy	-target="module.eks" -var-file=$(VARS_FILE) -auto-approve

destroy-airflow:
	terraform destroy -target="module.airflow" -var-file=$(VARS_FILE) -auto-approve

destroy-mlflow:
	terraform destroy -target="module.mlflow" -var-file=$(VARS_FILE) -auto-approve

destroy-coder:
	terraform destroy -target="module.coder" -var-file=$(VARS_FILE) -auto-approve

# wipe-tf-state:
# 	terraform state rm $$(terraform state list)

# don't create executables
.PHONY: *
