# Links, Articles, and helpful commands and tips

## Helpful Links and Articles

Here are some useful links and articles related to the project:

## EKS Workshop Scaling
- [EKS Workshop Scaling](https://archive.eksworkshop.com/beginner/080_scaling/deploy_ca/)

## JupyterHub Deployment
- [Zero to JupyterHub](https://github.com/jupyterhub/zero-to-jupyterhub-k8s)
- [JupyterHub Helm Chart](https://hub.jupyter.org/helm-chart/)
- [Medium Article by Nils Braun](https://nils-braun.medium.com/deploying-a-free-multi-user-browser-only-ide-in-just-a-few-minutes-d891f803224b)
- [JupyterHub Installation Guide](https://z2jh.jupyter.org/en/latest/jupyterhub/installation.html)
- [Connect to JupyterHub from Visual Studio Code](https://blog.jupyter.org/connect-to-a-jupyterhub-from-visual-studio-code-ed7ed3a31bcb)

## Amazon EKS with Terraform
- [Create EKS Cluster using Terraform Modules](https://antonputra.com/amazon/create-eks-cluster-using-terraform-modules/#add-iam-user-role-to-eks)
- [EKS Cluster Autoscaler](https://letsmake.cloud/eks-cluster-autoscaler)
- [Example EKS Public Cluster Terraform Config](https://github.com/jenkins-infra/aws/blob/27d4f746748edcdb3ba49643cae3d2d329fb3153/eks-public-cluster.tf#L37-L42)
- [Using AWS EBS CSI Driver Add-on with AWS EKS Terraform Module](https://stackoverflow.com/questions/74648632/how-do-i-use-the-aws-ebs-csi-driver-addon-when-using-the-aws-eks-terraform-modul)

Feel free to explore these resources to gain insights and assistance with your project. Good luck!


## Tips and Useful Commands for the Project

## In regards to deletion:

1. **Check EFS Storage Classes:**
   Before deleting, verify that all EFS (Elastic File System) storage classes are deleted. This ensures there are no lingering resources that might cause issues during deletion.
2. **Check Load Balancers (LBs):**
   Ensure all Load Balancers (LBs) associated with the project are deleted. Failure to do so may prevent the deletion of the Virtual Private Cloud (VPC) due to lingering dependencies.
3. **Delete EC2 Route Table:**
   To delete a specific EC2 Route Table, use the following command:
   ```bash
   aws ec2 delete-route-table --route-table-id <route-table-id>
   ```
4. **Delete EC2 Network ACL:**
   To delete an EC2 Network ACL, use the following command:
   ```bash
   aws ec2 delete-network-acl --network-acl-id <network-acl-id>
   ```
To delete a load balancer and a NAT gateway, you can use the following AWS CLI commands:
5. **Delete Load Balancer:**
    To delete a load balancer, use the following command:
    ```bash
    aws elbv2 delete-load-balancer --load-balancer-arn <load-balancer-arn>
    ```
6. **## Delete NAT Gateway:**
    Before deleting a NAT gateway, ensure that it is not being used by any resources. Delete it by using the following command:
    ```bash
    aws ec2 delete-nat-gateway --nat-gateway-id <nat-gateway-id>
    ```

Please be cautious while using these commands, as they will permanently delete the specified resources. Make sure you are confident about the resources you are deleting and their impact on your environment.

## Kubernetes Commands:

1. **Export Namespace Configuration:**
   To export the configuration of a namespace (e.g., "airflow") to a JSON file named "admins.json," use the following command:
   ```
   kubectl get namespace airflow -o json > admins.json
   ```
2. **Finalize Namespace Deletion:**
   To finalize the deletion of a namespace (e.g., "airflow") after its resources have been removed, use the following command:
   ```
   kubectl replace --raw "/api/v1/namespaces/airflow/finalize" -f ./admins.json
   ```

