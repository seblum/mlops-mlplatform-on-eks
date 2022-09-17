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
