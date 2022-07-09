DO NOT FORGET **terraform destroy** & **variable deletion**!!!


## Structure

```
project
│   README.md
│   .gitignore
│
└───deployments
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

- [ ] write github actions to deploy automatically
- [ ] secrets to github actions
- [ ] refactor tf code with subdirs
- [ ] own directory for yaml 
- [ ] deploy yamls on rollout

```bash
aws eks --region eu-central-1 update-kubeconfig --name eks_education-eks-ueIuFx6S -raw cluster_name
```

### References
https://learn.hashicorp.com/tutorials/terraform/eks



