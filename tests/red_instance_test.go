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

func getAWSRegion() string {
	if r := os.Getenv("AWS_REGION"); r != "" {
		return r
	}
	if r := os.Getenv("AWS_DEFAULT_REGION"); r != "" {
		return r
	}
	return "us-east-1"
}

// Path 1: the module provisions its own network (create_vpc = true).
func TestRedInstanceCreatesNetwork(t *testing.T) {
	t.Parallel()

	awsRegion := getAWSRegion()
	projectName := fmt.Sprintf("red-inst-own-%s", strings.ToLower(random.UniqueId()))
	instanceName := fmt.Sprintf("red-%s", strings.ToLower(random.UniqueId()))

	opts := &terraform.Options{
		TerraformDir: "../examples/complete",
		Vars: map[string]interface{}{
			"region":        awsRegion,
			"project_name":  projectName,
			"instance_name": instanceName,
		},
	}

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraform.Destroy(t, opts)
	})

	test_structure.RunTestStage(t, "setup", func() {
		terraform.InitAndApply(t, opts)
	})

	test_structure.RunTestStage(t, "validate", func() {
		instanceID := terraform.Output(t, opts, "instance_id")
		if instanceID == "" || !strings.HasPrefix(instanceID, "i-") {
			t.Fatalf("Expected an instance ID starting with 'i-', got: %q", instanceID)
		}

		publicIP := terraform.Output(t, opts, "public_ip")
		if publicIP == "Public IP not allocated" || publicIP == "" {
			t.Fatalf("Expected a public IP, got: %q", publicIP)
		}
	})
}

// Path 2: the module consumes an externally-provided network
// (create_vpc = false, vpc_id/subnet_id supplied by the caller).
func TestRedInstanceUsesExistingNetwork(t *testing.T) {
	t.Parallel()

	awsRegion := getAWSRegion()
	projectName := fmt.Sprintf("red-inst-ext-%s", strings.ToLower(random.UniqueId()))
	instanceName := fmt.Sprintf("red-%s", strings.ToLower(random.UniqueId()))

	opts := &terraform.Options{
		TerraformDir: "../examples/existing-network",
		Vars: map[string]interface{}{
			"region":        awsRegion,
			"project_name":  projectName,
			"instance_name": instanceName,
		},
	}

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraform.Destroy(t, opts)
	})

	test_structure.RunTestStage(t, "setup", func() {
		terraform.InitAndApply(t, opts)
	})

	test_structure.RunTestStage(t, "validate", func() {
		instanceID := terraform.Output(t, opts, "instance_id")
		if instanceID == "" || !strings.HasPrefix(instanceID, "i-") {
			t.Fatalf("Expected an instance ID starting with 'i-', got: %q", instanceID)
		}

		// The externally-created VPC must actually exist and be a real VPC.
		suppliedVPC := terraform.Output(t, opts, "supplied_vpc_id")
		if !strings.HasPrefix(suppliedVPC, "vpc-") {
			t.Fatalf("Expected supplied VPC ID starting with 'vpc-', got: %q", suppliedVPC)
		}

		// When create_vpc = false, the module reports the inherited-network
		// sentinel rather than creating its own VPC.
		moduleVPC := terraform.Output(t, opts, "vpc_id")
		if strings.HasPrefix(moduleVPC, "vpc-") {
			t.Fatalf("Module appears to have created its own VPC (%q) despite create_vpc = false", moduleVPC)
		}
	})
}
