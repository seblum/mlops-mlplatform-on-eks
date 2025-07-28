package tests

import (
  "testing"

  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
)

func TestTfstateBackendModule(t *testing.T) {
  t.Parallel()

  terraformOptions := &terraform.Options{
    TerraformDir: "../deployment/modules/tfstate-backend",
    Vars: map[string]interface{}{
      "bucket_name":      "terratest-tfstate-bucket",
      "lock_table_name":  "terratest-tfstate-lock-table",
      "tags": map[string]string{
        "Test": "Terratest",
      },
    },
    NoColor: true,
  }

  // Initialize and validate (no apply to keep tests cheap)
  _, err := terraform.InitAndValidateE(t, terraformOptions)
  assert.NoError(t, err)
}
