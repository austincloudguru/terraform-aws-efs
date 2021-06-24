package test

import (
	"testing"
	"github.com/stretchr/testify/assert"
    "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesTerraform(t *testing.T) {
	t.Parallel()
	terraformOpts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Our Terraform code is in the /aws folder.
		TerraformDir: "../examples/terratest/",
		// BackendConfig: map[string]interface{}{
		// 	"path": "/go/src/terraform.state",
		// },
	})

	defer terraform.Destroy(t, terraformOpts)
	terraform.InitAndApply(t, terraformOpts)

	efsArn := terraform.Output(t, terraformOpts, "efs_arn")
	assert.Contains(t, efsArn, "arn:aws:elasticfilesystem:us-west-2:")

	efsId := terraform.Output(t, terraformOpts, "efs_id")
	efsDns := terraform.Output(t, terraformOpts, "efs_dns_name")
	assert.Contains(t, efsDns, efsId)

	efsSgName := terraform.Output(t, terraformOpts, "sg_name")
	assert.Contains(t, efsSgName, "terratest-efs")


}
