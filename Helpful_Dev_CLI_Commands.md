
## In General

Verify if all EFS storage classes have been removed and confirm the deletion of load balancers (LBs), as the VPC deletion process is dependent on LB removal.

## AWS Commands:

```bash
aws ec2 delete-route-table --route-table-id
aws ec2 delete-network-acl

# delete loadbalancer
# delete nat-gateaway
```

## Kubernetes Commands:

```bash
# To export the configuration of a namespace (e.g., "airflow") to a JSON file named "admins.json," use the following command:
kubectl get namespace airflow -o json > admins.json
# To finalize the deletion of a namespace (e.g., "airflow") after its resources have been removed, use the following command:
kubectl replace --raw "/api/v1/namespaces/airflow/finalize" -f ./admins.json
```

```bash
kubectl get namespace airflow -o json > admins.json
kubectl replace --raw "/api/v1/namespaces/airflow/finalize" -f ./admins.json

kubectl get namespace yatai-system -o json > admins.json
kubectl replace --raw "/api/v1/namespaces/yatai-system/finalize" -f ./admins.json

kubectl get namespace sagemaker-dashboard -o json > admins.json
kubectl replace --raw "/api/v1/namespaces/sagemaker-dashboard/finalize" -f ./admins.json
```


