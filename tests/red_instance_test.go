package test

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

var (
	awsRegion   = os.Getenv("AWS_REGION")
	projectName = fmt.Sprintf("red-instance-%s", strings.ToLower(random.UniqueId()))
	opts        = &terraform.Options{
		TerraformDir: ".",
		Vars: map[string]interface{}{
			"region":       awsRegion,
			"project_name": projectName,
		},
	}
)

// Destroy the terraform code
func destroyTerraform(t *testing.T) {
	terraform.Destroy(t, opts)
}

// Deploy the terraform code
func deployTerraform(t *testing.T) {
	_, err := terraform.InitAndApplyE(t, opts)
	if err != nil {
		terraform.Apply(t, opts)
	}
}

// Test the Red Instance terraform module
func TestRedInstance(t *testing.T) {
	defer test_structure.RunTestStage(t, "terraform_destroy", func() {
		destroyTerraform(t)
	})

	test_structure.RunTestStage(t, "terraform_init_and_apply", func() {
		deployTerraform(t)
	})
}
