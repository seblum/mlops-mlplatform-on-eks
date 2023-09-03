# ML Platform on EKS

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
│   └── profiles
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

The project *ML Platform on EKS* provides a comprehensive machine learning platform on AWS EKS, utilizing powerful tools and technologies to streamline machine learning workflows and facilitate collaboration among data scientists and ML practitioners. The platform's automation and deployment features make it easy to set up and manage, while the exemplary deep learning use case serves as a valuable resource for users to kickstart their own ML projects. The main features of the "ML Platform on EKS" project can be described as follows:

1. **ML Platform on Kubernetes (EKS)**: The project aims to set up a complete Machine Learning (ML) platform on Kubernetes using Amazon EKS (Elastic Kubernetes Service). This allows users to leverage the power of Kubernetes for orchestrating containerized ML workloads.
2. **MLOps Framework**: The platform is designed to support MLOps practices, enabling end-to-end automation, monitoring, and collaboration for ML workflows. MLOps helps streamline the development, deployment, and management of ML models, enhancing productivity and reliability.
3. **AWS Terraform Infrastructure**: The project uses Terraform to create and manage the entire infrastructure on AWS. This includes the Virtual Private Cloud (VPC), Amazon EKS cluster, networking components, and RDS (Relational Database Service) setup.
4. **AWS ALB and Route 53**: Load balancing and DNS management are implemented using AWS Application Load Balancer (ALB) and Amazon Route 53, respectively. This ensures high availability and efficient traffic routing for the ML platform.
5. **Airflow, MLFlow, and JupyterHub**: The ML platform utilizes three essential components - Airflow, MLFlow, and JupyterHub - to support different aspects of the ML workflow. These tools enable workflow orchestration, model tracking, and collaborative Jupyter notebooks.
6. **Integration with Sagemaker Endpoints:** Incorporating the capability to deploy to Sagemaker endpoints with associated roles and enabling the representation of these endpoints within a customized Streamlit application.
7. **Comprehensive Tool Display on Dashboard:** A Vue.js-based custom dashboard provides an overarching view of each individual tool, presenting a cohesive visual representation of the platform's functionalities and interactions.
8.  **Helm Charts for Deployment**: The platform leverages Helm charts for deploying Airflow, MLFlow, and JupyterHub. Helm simplifies the installation and management of complex applications on Kubernetes.
9.  **GitHub OAuth Authentication**: Each component of the ML platform is secured with GitHub OAuth authentication. This ensures that only authorized users can access and interact with the platform.
10. **Exemplary Deep Learning Use Case**: The project provides an exemplary deep learning use case that demonstrates how to integrate Airflow and MLFlow. This use case can serve as a reference for users to build their ML workflows.
11. **Terraform Deployment Automation**: The project offers a straightforward deployment process using Terraform. Users can specify parameters in a `.tfvar` file and apply the configuration to set up the entire ML platform.
12. **GitHub Actions for Continuous Deployment**: The project plans to implement GitHub Actions to enable automated continuous deployment, making it easier to update and manage the platform.
13. **Monitoring and Scaling Considerations**: The project mentions plans to implement monitoring, likely using Grafana, to keep track of platform performance. Additionally, it aims to enable autoscaling to adjust resources based on demand.

## Installation / Deployment

Follow the deployment setup and its prerequistes in the dedidacted [Installation Document](./Installation.md).

## Contributing

Contributions to *ML Platform on EKS* are highly appreciated! Whether you come across issues, bugs, or have ideas for improvements, we encourage you to actively participate in the project. Should you encounter any problems while using the platform, please don't hesitate to open a new issue on the GitHub repository. Similarly, if you have bug fixes, new features, or enhancements to offer, you can contribute by submitting a pull request (PR). Please ensure that your changes undergo comprehensive testing and adhere to the project's coding conventions before creating the PR. Your contributions play a vital role in enhancing the project's functionality and overall quality. Thank you for considering contributing to *ML Platform on EKS*!

## License

This repository is licensed under the Apache License, Version 2.0. The Apache License is an open-source license that allows users to freely use, modify, distribute, and sublicense the code.

Please refer to the [LICENSE](LICENSE) file in this repository for the full text of the Apache License, Version 2.0. By using, contributing, or distributing this repository, you agree to be bound by the terms and conditions of the Apache License.
