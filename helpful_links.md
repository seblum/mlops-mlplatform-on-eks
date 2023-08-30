
# Helpful links

## EKS

+ https://antonputra.com/amazon/create-eks-cluster-using-terraform-modules/#add-iam-user-role-to-eks
+ https://letsmake.cloud/eks-cluster-autoscaler
+ https://github.com/jenkins-infra/aws/blob/27d4f746748edcdb3ba49643cae3d2d329fb3153/eks-public-cluster.tf#L37-L42
+ https://stackoverflow.com/questions/74648632/how-do-i-use-the-aws-ebs-csi-driver-addon-when-using-the-aws-eks-terraform-modul


## JupyterHub

https://blog.jupyter.org/connect-to-a-jupyterhub-from-visual-studio-code-ed7ed3a31bcb



# In regards to deletion:

check whether all efs storage classes are deleted
check whether lbs are deleted, otherwise vpc cannot be deleted


aws ec2 delete-route-table --route-table-id
aws ec2 delete-network-acl


kubectl get namespace airflow -o json > admins.json
kubectl replace --raw "/api/v1/namespaces/airflow/finalize" -f ./admins.json


kubectl get namespace yatai-system -o json > admins.json
kubectl replace --raw "/api/v1/namespaces/yatai-system/finalize" -f ./admins.json

kubectl get namespace sagemaker-dashboard -o json > admins.json
kubectl replace --raw "/api/v1/namespaces/sagemaker-dashboard/finalize" -f ./admins.json


delete loadbalancer
delete nat-gateaway