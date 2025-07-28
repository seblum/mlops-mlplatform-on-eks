# External Secrets Operator Integration

This document explains how to enable the External Secrets Operator (ESO) on the ML Platform on EKS stack and migrate a component (MLflow) away from inline Kubernetes `Secret` objects.

## 1. Prerequisites

1. EKS cluster is up and running.
2. The `external-secrets` module has been applied:
   ```hcl
   module "external_secrets" {
     source        = "./deployment/modules/external-secrets"
     irsa_role_arn = aws_iam_role.external_secrets.arn
   }
   ```
3. An IAM role (IRSA) with permission to read specific AWS Secrets Manager entries is available.

## 2. Create Secret in AWS Secrets Manager

```bash
aws secretsmanager create-secret \
  --name mlflow-rds \
  --description "RDS credentials for MLflow" \
  --secret-string '{
    "username":"mlflow_user",
    "password":"<super-secret-password>",
    "host":"mlflow-db.cluster-abcdefgh.us-east-1.rds.amazonaws.com",
    "port":"5432"
  }'
```

## 3. Configure `ClusterSecretStore`

Create (or reuse) a store that tells ESO where to fetch secrets:

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: aws-secrets-manager
spec:
  provider:
    aws:
      service: SecretsManager
      region: us-east-1
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets-sa
            namespace: external-secrets
```

## 4. Enable ESO for MLflow Helm Chart

1. In your `terraform.tfvars` or stack variables, set:
   ```hcl
   mlflow_values = {
     externalSecrets = {
       enabled        = true
       rdsSecretName  = "mlflow-rds"
       storeRef = {
         name = "aws-secrets-manager"
         kind = "ClusterSecretStore"
       }
     }
   }
   ```
2. Apply Terraform. The MLflow release will render an `ExternalSecret` object (defined in `templates/externalsecret.yaml`). ESO creates/updates the Kubernetes Secret on a regular schedule.
3. The original inline `secret.yaml` remains in the chart but will be **ignored** when `externalSecrets.enabled` is `true`.

## 5. Verifying

```bash
kubectl get externalsecret -n mlflow
kubectl describe externalsecret mlflow-secret -n mlflow
kubectl get secret mlflow-secret -n mlflow -o yaml
```
You should see the synced data with type `Opaque`.

## 6. Rolling Back

If something goes wrong:
1. Disable ESO in values (`externalSecrets.enabled = false`).
2. Re-apply Terraform – chart falls back to inline secret.
3. Once fixed, re-enable ESO and apply again.

---
Last updated: {{< date >}}
