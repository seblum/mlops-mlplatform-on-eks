# MLOps Airflow on EKS

This project aims to develop a machine learning (ML) platform on Kubernetes that facilitates the MLOps framework. The entire infrastructure is provisioned on AWS using Terraform. Load balancing and DNS management are handled using AWS ALB and Route 53, respectively.

The ML platform incorporates Airflow, MLFlow, and JupyterHub, which are deployed using the Helm provider. Specifically, the Airflow community Helm chart, the JupyterHub official Helm chart, and a custom Helm chart for MLFlow are utilized. To ensure security, each component is protected by GitHub OAuth authentication.

As a demonstration of the platform's capabilities, an exemplary deep learning use case is implemented. This use case leverages Airflow and MLFlow to showcase the platform's workflow management and model tracking features. The code for this use case can be found in [this repository](https://github.com/seblum/mlops-airflow-DAGs).

Additionally, this project is an integral part of the larger ML engineering [bookdown project](https://github.com/seblum/mlops-engineering-book), which aims to provide comprehensive insights and guidance on MLOps engineering practices.

## Repository Structure

The project repository is organized as follows:

```
project
│   README.md
│   .gitignore
│
└─── .github.workflows
│
└─── deployment
│   │   root
│   │   main.tf
│   │   variables.tf
│   │   outputs.tf
│   │   providers.tf
│   │
│   └── infrastructure
│   │   │
│   │   └── vpc
│   │   │
│   │   └── eks
│   │   │   
│   │   └── networking
│   │   │   
│   │   └── rds
│   │
│   └── modules
│       │
│       └── airflow
│       │
│       └── dashboard
│       │
│       └── jupyterhub
│       │
│       └── mlflow
│       │
│       └── monitoring
│       │
│       └── sagemaker
│       │
│       └── user-profiles
```

## Features

The project *MLOps Airflow on EKS* provides a comprehensive machine learning platform on AWS EKS, utilizing powerful tools and technologies to streamline machine learning workflows and facilitate collaboration among data scientists and ML practitioners. The platform's automation and deployment features make it easy to set up and manage, while the exemplary deep learning use case serves as a valuable resource for users to kickstart their own ML projects. The main features of the "MLOps Airflow on EKS" project can be described as follows:

1. **ML Platform on Kubernetes (EKS)**: The project aims to set up a complete Machine Learning (ML) platform on Kubernetes using Amazon EKS (Elastic Kubernetes Service). This allows users to leverage the power of Kubernetes for orchestrating containerized ML workloads.
2. **MLOps Framework**: The platform is designed to support MLOps practices, enabling end-to-end automation, monitoring, and collaboration for ML workflows. MLOps helps streamline the development, deployment, and management of ML models, enhancing productivity and reliability.
3. **AWS Terraform Infrastructure**: The project uses Terraform to create and manage the entire infrastructure on AWS. This includes the Virtual Private Cloud (VPC), Amazon EKS cluster, networking components, and RDS (Relational Database Service) setup.
4. **AWS ALB and Route 53**: Load balancing and DNS management are implemented using AWS Application Load Balancer (ALB) and Amazon Route 53, respectively. This ensures high availability and efficient traffic routing for the ML platform.
5. **Airflow, MLFlow, and JupyterHub**: The ML platform utilizes three essential components - Airflow, MLFlow, and JupyterHub - to support different aspects of the ML workflow. These tools enable workflow orchestration, model tracking, and collaborative Jupyter notebooks.
6. **Helm Charts for Deployment**: The platform leverages Helm charts for deploying Airflow, MLFlow, and JupyterHub. Helm simplifies the installation and management of complex applications on Kubernetes.
7. **GitHub OAuth Authentication**: Each component of the ML platform is secured with GitHub OAuth authentication. This ensures that only authorized users can access and interact with the platform.
8. **Exemplary Deep Learning Use Case**: The project provides an exemplary deep learning use case that demonstrates how to integrate Airflow and MLFlow. This use case can serve as a reference for users to build their ML workflows.
9. **Terraform Deployment Automation**: The project offers a straightforward deployment process using Terraform. Users can specify parameters in a `.tfvar` file and apply the configuration to set up the entire ML platform.
10. **GitHub Actions for Continuous Deployment**: The project plans to implement GitHub Actions to enable automated continuous deployment, making it easier to update and manage the platform.
11. **Monitoring and Scaling Considerations**: The project mentions plans to implement monitoring, likely using Grafana, to keep track of platform performance. Additionally, it aims to enable autoscaling to adjust resources based on demand.

## Installation / Deployment

Before proceeding with the installation, ensure that you have the following prerequisites installed on your system:

- AWS CLI
- kubectl
- Terraform

Follow these steps to deploy the ML platform on AWS EKS:

1. Create a file named `<NAME>.tfvar` with the specified parameters. This file will hold the configuration for the deployment. The contents of `<NAME>.tfvar` should resemble the following YAML format:

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

2. Run the Terraform script using either of the following commands:
   - `terraform apply`
   - `terraform apply -var-file="<NAME>.tfvars"`

3. Once the deployment is complete, you will receive a public endpoint URL. Use this URL to access the ML platform.

4. Access each component of the platform using the following URLs:
   - Airflow: `domain-name/airflow`
   - MLFlow: `domain-name/mlflow`
   - JupyterHub: `domain-name/jupyterhub`

5. The main deployment can be accessed at `domain-name/`.


### Makefile

The Makefile included in this repository simplifies common tasks and commands for project management. It will automatically execute the corresponding commands, saving you time and effort. Refer to the Makefile for a full list of available targets and their functionalities. To utilize the Makefile, follow these steps:

1. Open your terminal or command prompt.
2. Navigate to the root directory of the project.
3. Type `make` followed by the target you want to execute (e.g., `make build`, `make test`).


### Pre-commit Hooks

Pre-commit hooks are automated checks that run before committing changes to the repository. To make the most of pre-commit hooks, follow these steps:

1. Ensure you have pre-commit installed on your system. If not, install it using pip: `pip install pre-commit`.
2. Navigate to the root directory of the project.
3. Run `pre-commit install` to set up the hooks for this repository.
4. Make your changes to the code or files.
5. Before committing, run `git add` for the modified files.
6. Finally, commit your changes as usual using `git commit -m "Your commit message"`.

The pre-commit hooks will automatically check your code for formatting issues, lint errors, or any other specified criteria. If any issues are found, the commit will be blocked until the problems are resolved. This ensures consistent code quality and reduces potential errors before they become part of the codebase.

## Contributing

Contributions to **MLOps Airflow on EKS** are highly appreciated! Whether you come across issues, bugs, or have ideas for improvements, we encourage you to actively participate in the project. Should you encounter any problems while using the platform, please don't hesitate to open a new issue on the GitHub repository. Similarly, if you have bug fixes, new features, or enhancements to offer, you can contribute by submitting a pull request (PR). Please ensure that your changes undergo comprehensive testing and adhere to the project's coding conventions before creating the PR. Your contributions play a vital role in enhancing the project's functionality and overall quality. Thank you for considering contributing to MLOps Airflow on EKS!

## TODOs

### General:
- [ ] Test GitHub actions for automatic deployment.
- [ ] Store Terraform state on S3 for improved management.
- [ ] Add secrets to GitHub actions for secure handling of sensitive information.
- [ ] Add pre-commit hooks for formatting YAML files to maintain consistent code style.
- [ ] Implement Airflow log storage to centralize and manage logs effectively.
- [ ] Set up monitoring, potentially using Grafana, to track platform performance.
- [ ] Explore and choose a serving tool to efficiently deploy and manage ML models.
- [ ] Enable autoscaling to dynamically adjust resources based on demand.

### Airflow Integration:
- [ ] Enable Airflow to utilize GPUs for accelerated processing.
- [ ] Integrate Airflow DAGs with MLFlow and TensorFlow for seamless ML workflow management.

### Security and User Management:
- [ ] Enhance cluster security to limit public access to sensitive components.
- [ ] Implement a consistent user management system for Airflow, JupyterHub, and MLFlow.

### JupyterHub Improvements:
- [ ] Allow JupyterHub to support multiple images for diverse user needs.
- [ ] Explore Helm list input for JupyterHub to enable dynamic management of Airflow DAG repositories.
- [ ] Health check for JupyterHub ALB is currently failing

### AWS Service Quota:
- [ ] Check AWS service quota for GPU instances to ensure sufficient resources.

## TODO Infrastructure:

### ExternalDNS Setup:
- [ ] Limit hosted zone in ExternalDNS for better control over DNS records.

### AWS EKS Cluster:
- [ ] Set EKS cluster to not be publicly accessible to improve security.

### EFS Module Integration:
- [ ] Consider using EFS module for easier setup and management of Elastic File System.


## License

This repository is licensed under the Apache License, Version 2.0. The Apache License is an open-source license that allows users to freely use, modify, distribute, and sublicense the code.

Please refer to the [LICENSE](LICENSE) file in this repository for the full text of the Apache License, Version 2.0. By using, contributing, or distributing this repository, you agree to be bound by the terms and conditions of the Apache License.
