# tfstate-backend Terraform Module

This module provisions an S3 bucket and DynamoDB table that can be used as a remote backend for Terraform state with locking enabled.

## Resources

1. **S3 Bucket** – versioned, encrypted, and with public access blocked.
2. **DynamoDB Table** – `PAY_PER_REQUEST` billing with `LockID` hash key for state locking.

## Usage

```hcl
module "tfstate_backend" {
  source = "./deployment/modules/tfstate-backend"

  bucket_name      = "my-terraform-state-bucket"
  lock_table_name  = "terraform-lock-table"
  tags = {
    Project = "ml-platform-on-eks"
  }
}
```

After creating the backend resources, configure each root module:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/stack.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `bucket_name` | Name of the S3 bucket to create/use for state | `string` | n/a |
| `lock_table_name` | Name of the DynamoDB table for locks | `string` | n/a |
| `tags` | Map of resource tags | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_name` | Name of the bucket created |
| `lock_table_name` | Name of the lock table created |

## Security & Compliance

* Bucket encryption is enforced (SSE-S3).
* Bucket is private with all public access blocked.
* Bucket has versioning enabled to allow recovery of previous state versions.
* `prevent_destroy` lifecycle rule helps avoid accidental state deletion.

## License

MIT - see [LICENSE](../../../LICENSE)
