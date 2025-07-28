# Migrating to Remote Terraform State

This guide walks you through moving each root Terraform stack from local `*.tfstate` files to the shared S3 + DynamoDB backend created by the `tfstate-backend` module.

## Prerequisites

1. The `tfstate-backend` module has been applied and you have the following values:
   * **Bucket name**
   * **DynamoDB lock table name**
   * **AWS region** where the bucket/table live
2. You are on the latest commit of `main`.
3. You have committed or backed-up any existing local state.

## Step-by-Step

### 1. Configure Backend Block

In each root directory (e.g. `deployment/bootstrap/`, `deployment/infrastructure/vpc/`, …), add this block at the top-level:

```hcl
terraform {
  backend "s3" {
    bucket         = "<state_bucket_name>"
    key            = "path/to/<stack>.tfstate"
    region         = "<aws_region>"
    dynamodb_table = "<state_lock_table>"
    encrypt        = true
  }
}
```

Use a unique `key` path per stack so state files don’t clash.

### 2. Initialize & Migrate State

```bash
cd deployment/bootstrap
terraform init -migrate-state -backend-config="bucket=<state_bucket_name>" \
               -backend-config="key=deployment/bootstrap.tfstate" \
               -backend-config="region=<aws_region>" \
               -backend-config="dynamodb_table=<state_lock_table>" \
               -backend-config="encrypt=true"
```

Terraform will detect the new backend and ask to copy the existing state file to S3. Type `yes` when prompted.

Repeat for every root stack.

### 3. Verify

1. Run `terraform plan` – output should show **no changes**.
2. In the AWS Console, verify the S3 object and DynamoDB lock table have entries.

### 4. Cleanup Local State (Optional)

After confirming all stacks are using remote state, you may delete local `*.tfstate` and `*.tfstate.backup` files or add them to `.gitignore` to avoid confusion.

## Rollback

If you need to revert to local state:

1. Comment out the `backend "s3" { ... }` block.
2. Run `terraform init -reconfigure`.
3. Replace the copied state locally with `aws s3 cp s3://<bucket>/path/to/stack.tfstate ./terraform.tfstate`.

## Best Practices

* Keep the S3 bucket versioned and enable MFA-delete if required.
* Restrict IAM policies so only CI and trusted operators can read/write state.
* Enable server-side encryption (already enforced by module).

---
Last updated: {{< date >}}
