package tests

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
)

func TestExternalSecretsModule(t *testing.T) {
  t.Parallel()

  terraformOptions := &terraform.Options{
    TerraformDir: "../deployment/modules/external-secrets",
    Vars: map[string]interface{}{
      "irsa_role_arn": "arn:aws:iam::123456789012:role/dummy",
    },
    NoColor: true,
  }

  _, err := terraform.InitAndValidateE(t, terraformOptions)
  assert.NoError(t, err)
}
