# MLOps Airflow on EKS

This project aims to build a MLops plattform on AWS EKS utilizing Airflow, MLFlow, and Jupyterhub.

## Structure

```
project
│   README.md
│   .gitignore
│
└─── deployment
│    │   main.tf
│    │
│    └─── applications
│    │    │ ...  
│    │
│    └─── infrastructure
│    │    │ ...
│    │
│    └─── modules
│         │ ...  
│
└─── .github.workflows

```

## ToDo
- [ ] test github actions to deploy automatically
- [ ] terraform state on s3
- [ ] secrets to github actions
- [ ] add pre-commit hooks for formating yaml
- [ ] Airflow log storage
- [ ] implement monitoring, probably grafana
- [ ] check for serving tool
- [ ] autoscaling 
- [ ] airflow GPUs
- [ ] Airflow DAGs with mlflow and tensorflow
- [ ] make cluster secure (endpoint is currently public)
- [ ] consistent users for airflow & jupyter? (mlflow?)
- [ ] Jupyterhub multiple images
- [ ] Jupyterhub helm list input (airflow dag repository)

## Deployment

1. set aws und kubectl cli
2. specify `<NAME>.tfvar` with below parameters
3. Run `terraform apply` or `terraform apply -var-file="<NAME>.tfvars"`
4. The endpoint is currently public, access it under the given endpoint url printed after applying


**`<NAME>.tfvar`**

```yaml
aws_region         = <AWS-REGION>
git_username       = <GIT-USERNAME>
git_token          = <GIT-TOKEN> 
git_repository_url = <GIT-REPOSITORY-TO-DAGS>
git_branch         = <GIT-REPOSITORY-TO-DAGS-BRANCH>
deploy_airflow     = <TRUE-OR-FALSE> (default true)
deploy_mlflow      = <TRUE-OR-FALSE> (default true)
deploy_jupyterhub  = <TRUE-OR-FALSE> (default true)
```