DO NOT FORGET **terraform destroy** & **variable deletion**!!!


## Structure

```
project
│   README.md
│   .gitignore
│
└───distribution
│   │   file011.txt
│   │   file012.txt
│   │
│   └───subfolder1
│       │   file111.txt
│       │   file112.txt
│       │   ...
│
└───eks_terraform
    │   file021.txt
    │   file022.txt
```

## ToDo
- [ ] make helm work
- [ ] write github actions to deploy automatically
- [ ] secrets to github actions
- [ ] refactor tf code with subdirs
- [ ] own directory for yaml
- [ ] deploy yamls on rollout
- [ ] add pre-commit hooks for formating yaml
- [ ] terraform state on s3

```bash
aws eks --region eu-central-1 update-kubeconfig --name eks_education-eks-ueIuFx6S -raw cluster_name
```

### References
https://learn.hashicorp.com/tutorials/terraform/eks



### Airflow

kubectl create namespace airflow
helm install airflow apache-airflow/airflow --namespace airflow --debug


# Deployment


1. set aws und kubectl cli
2. Run `terraform apply` or `terraform apply -var-file="testing.tfvars"`
3. The endpoint is currently public, access it under the given endpoint url printed after applying



Set up Airflow ssh keys
https://airflow.apache.org/docs/helm-chart/stable/manage-dags-files.html

create ssh key
set it to deploy key in private github repo
reference to it within your terraform code OR put it into Github actions secret
