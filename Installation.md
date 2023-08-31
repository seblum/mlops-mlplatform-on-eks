# Installation / Deployment

The installation and deployment process involves several key steps to ensure a smooth setup of your environment:

## Prerequisites

Before proceeding with the installation, it's crucial to complete the following essential prerequisites: installing the necessary tools, establishing a GitHub organization along with OAuth apps, and obtaining a DNS name to link with your services.

### Tools needed

Before you begin with the installation process, make sure you have the following prerequisites installed on your system. You can find installation guides for each tool at the provided links:

1. **AWS CLI**: The AWS Command Line Interface (CLI) is essential for interacting with AWS services. You can install it by following the instructions on the [official AWS CLI installation guide](https://aws.amazon.com/cli/).
2. **kubectl**: Kubernetes command-line tool, `kubectl`, is crucial for managing Kubernetes clusters. You can install it using the steps outlined in the [Kubectl Installation Documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
3. **Terraform**: Terraform is used for provisioning infrastructure as code. Install Terraform by referring to the installation steps in the [Terraform Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli).

### Setting Up GitHub OAuth App for Integration

To seamlessly integrate each application of the ML platform with GitHub and allow Github Sign-In, you can follow these steps to set up a GitHub OAuth app within your organization:

1. **Create a GitHub Organization**: If you haven't already, create a GitHub organization where you want to manage your OAuth app. Learn more about creating organizations in the [GitHub documentation](https://docs.github.com/en/organizations/creating-a-new-organization).
2. **Create an OAuth App**: Inside your GitHub organization, navigate to the "Settings" tab, and then to "OAuth Apps." Click on the "New OAuth App" button to create a new app. Fill in the necessary details, including the callback URL and permissions required.
3. **Get Client ID and Token**: After creating the OAuth app, you'll receive a Client ID and Client Secret. These are essential for authenticating your app. To obtain these credentials, go to the app's settings page and find the "Client ID" and "Client Secret" sections.
4. **Create Teams for Airflow Access** Create a team named *"airflow-users-team"* and another team named *"airflow-admin-team"* within your GitHub organization. These teams will be used to manage access rights to the Airflow setup.

For more detailed guidance on setting up a GitHub OAuth app within your organization and obtaining the necessary credentials, refer to the [GitHub OAuth documentation](https://docs.github.com/en/developers/apps/creating-an-oauth-app) and the [GitHub Organization documentation](https://docs.github.com/en/organizations). These resources will provide you with step-by-step instructions and best practices for successful integration.

### Obtaining a DNS Name and Configuring AWS Route 53

Before deploying your ML platform, you need to acquire a DNS name to provide a user-friendly web address for accessing your services. Here's how you can get a DNS name and set it up using AWS Route 53:

1. **Purchase a Domain Name**: Choose and purchase a domain name from a domain registrar. Popular options include AWS Route 53 itself, GoDaddy, Namecheap, and others. Ensure that the domain is available for purchase.
2. **Configure Route 53 Hosted Zone**:
   - Create a new hosted zone in AWS Route 53 that corresponds to your purchased domain. This establishes a connection between your domain and the Route 53 service. Follow the [AWS Route 53 documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) for detailed steps.
3. **Update Domain Name Servers (DNS)**:
   - After creating the hosted zone, Route 53 provides a set of DNS name servers. Update your domain registrar's settings to point to these Route 53 name servers. This step enables Route 53 to manage your domain's DNS records. Refer to the [Route 53 documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring.html) for guidance.
4. **Create Required DNS Records**:
   - In your Route 53 hosted zone, create the necessary DNS records to associate your services with your domain. For example, you might create an "A" record to map your domain to your ML platform's IP address. The [Route 53 documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-creating.html) provides instructions for creating different types of DNS records.
5. **Verify and Test**: Once your DNS records are set up, it might take some time for changes to propagate across the internet. You can use tools like `nslookup` or online DNS lookup tools to verify that your domain is correctly configured.

For a more in-depth walkthrough and troubleshooting guidance, consult the [AWS Route 53 documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/welcome.html) or consider resources like *Medium* that offer step-by-step instructions and practical tips for setting up DNS on AWS Route 53.

Once you have these prerequisites in place, you'll be well-prepared to proceed with the deployment of the ML Platform.


## Deployment

To deploy the ML platform on AWS EKS:

1. Create a file named `<NAME>.tfvar` with the specified parameters. This file will hold the configuration for the deployment. The contents of `<NAME>.tfvar` should resemble the following YAML format:
```yaml
domain_name  = <DOMAIN-NAME>

git_username            = <GIT-USERNAME>
git_token               = <GIT-TOKEN>
git_sync_repository_url = <GIT-REPOSITORY-TO-DAGS>
git_sync_branch         = <GIT-REPOSITORY-TO-DAGS-BRANCH>

airflow_git_client_id     = "<AIRFLOW-GIT-CLIENT-ID>"
airflow_git_client_secret = "<AIRFLOW-GIT-CLIENT-SECRET>"
airflow_fernet_key        = "<AIRFLOW-FERNET-KEY>"

mlflow_git_client_id     = "<MLFLOW-GIT-CLIENT-ID>"
mlflow_git_client_secret = "<MLFLOW-GIT-CLIENT-SECRET>"

grafana_git_client_id     = "<GRAFANA-GIT-CLIENT-ID>"
grafana_git_client_secret = "<GRAFANA-GIT-CLIENT-SECRET>"

jupyterhub_git_client_id      = "<JUPYTERHUB-GIT-CLIENT-ID>"
jupyterhub_git_client_secret  = "<JUPYTERHUB-GIT-CLIENT-SECRET>"
jupyterhub_proxy_secret_token = "<JUPYTERHUB-PROXY-SECRET-TOKEN>"

deploy_airflow     = <TRUE-OR-FALSE> (default true)
deploy_mlflow      = <TRUE-OR-FALSE> (default true)
deploy_jupyterhub  = <TRUE-OR-FALSE> (default true)
deploy_monitoring  = <TRUE-OR-FALSE> (default true)
deploy_dashboard   = <TRUE-OR-FALSE> (default true)
deploy_sagemaker   = <TRUE-OR-FALSE> (default true)
```

2. Run the Terraform script using either of the following commands:
   - `terraform apply`
   - `terraform apply -var-file="<NAME>.tfvars"`
   - You can also use the provided makefile
3. Once the deployment is complete, you can access your ML platform using your given domain URL.
4. Access each component of the platform using their domain URLs and path, for example for Airflow: `domain-name/airflow`
5. The main dashboard can be accessed at `domain-name/main`.
6. Destroy the ML Platform using:
   - `terraform destroy -var-file="<NAME>.tfvars"`


## Makefile

The Makefile included in this repository simplifies common tasks and commands for project management. It will automatically execute the corresponding commands, saving you time and effort. Refer to the Makefile for a full list of available targets and their functionalities. To utilize the Makefile, follow these steps:

1. Open your terminal or command prompt.
2. Navigate to the root directory of the project.
3. Type `make` followed by the target you want to execute (e.g., `make deploy-all`, `make destroy-all`).
