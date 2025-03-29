package test

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

// TestDNSOnlyFeature tests the Red Instance with only DNS feature enabled
func TestDNSOnlyFeature(t *testing.T) {
	t.Parallel()

	// Get the current AWS region from environment variable or use default
	awsRegion := os.Getenv("AWS_REGION")
	if awsRegion == "" {
		awsRegion = "us-east-1"
	}

	// Generate a unique project name for the test
	projectName := fmt.Sprintf("red-dns-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir: "./dns-only",
		Vars: map[string]interface{}{
			"region":       awsRegion,
			"project_name": projectName,
		},
	}

	// Clean up resources in the end
	defer test_structure.RunTestStage(t, "teardown", func() {
		terraform.Destroy(t, terraformOptions)
	})

	// Deploy using Terraform
	test_structure.RunTestStage(t, "setup", func() {
		terraform.InitAndApply(t, terraformOptions)
	})

	// Validate outputs
	test_structure.RunTestStage(t, "validate", func() {
		vpcID := terraform.Output(t, terraformOptions, "vpc_id")
		subnetID := terraform.Output(t, terraformOptions, "subnet_id")
		publicIP := terraform.Output(t, terraformOptions, "public_ip")
		publicDNS := terraform.Output(t, terraformOptions, "public_dns")

		// Basic validation
		if vpcID == "" {
			t.Fatal("Expected VPC ID to be set, but was empty")
		}
		if subnetID == "" {
			t.Fatal("Expected Subnet ID to be set, but was empty")
		}
		if publicIP == "Public IP not allocated" {
			t.Fatal("Expected public IP to be allocated but it was not")
		}
		if publicDNS == "Public DNS not allocated" {
			t.Fatal("Expected public DNS to be set but it was not")
		}
	})
}

// TestS3AccessFeature tests the Red Instance with S3 bucket access feature enabled
func TestS3AccessFeature(t *testing.T) {
	t.Parallel()

	// Get the current AWS region from environment variable or use default
	awsRegion := os.Getenv("AWS_REGION")
	if awsRegion == "" {
		awsRegion = "us-east-1"
	}

	// Generate a unique project name and S3 bucket name for the test
	projectName := fmt.Sprintf("red-s3-%s", strings.ToLower(random.UniqueId()))
	bucketName := fmt.Sprintf("test-bucket-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir: "./s3-access",
		Vars: map[string]interface{}{
			"region":         awsRegion,
			"project_name":   projectName,
			"s3_bucket_name": bucketName,
		},
	}

	// Clean up resources in the end
	defer test_structure.RunTestStage(t, "teardown", func() {
		terraform.Destroy(t, terraformOptions)
	})

	// Deploy using Terraform
	test_structure.RunTestStage(t, "setup", func() {
		terraform.InitAndApply(t, terraformOptions)
	})

	// Validate outputs
	test_structure.RunTestStage(t, "validate", func() {
		publicDNS := terraform.Output(t, terraformOptions, "public_dns")
		publicIP := terraform.Output(t, terraformOptions, "public_ip")

		// S3 test validations
		if publicDNS != "Public DNS not allocated" {
			t.Fatal("Expected public DNS to be not allocated, but it was set")
		}
		if publicIP == "Public IP not allocated" {
			t.Fatal("Expected public IP to be allocated but it was not")
		}
	})
}

// TestAllFeaturesEnabled tests the Red Instance with all features enabled
func TestAllFeaturesEnabled(t *testing.T) {
	t.Parallel()

	// Get the current AWS region from environment variable or use default
	awsRegion := os.Getenv("AWS_REGION")
	if awsRegion == "" {
		awsRegion = "us-east-1"
	}

	// Generate a unique project name and S3 bucket name for the test
	projectName := fmt.Sprintf("red-full-%s", strings.ToLower(random.UniqueId()))
	bucketName := fmt.Sprintf("full-test-bucket-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir: "./full-force",
		Vars: map[string]interface{}{
			"region":         awsRegion,
			"project_name":   projectName,
			"s3_bucket_name": bucketName,
		},
	}

	// Clean up resources in the end
	defer test_structure.RunTestStage(t, "teardown", func() {
		terraform.Destroy(t, terraformOptions)
	})

	// Deploy using Terraform
	test_structure.RunTestStage(t, "setup", func() {
		terraform.InitAndApply(t, terraformOptions)
	})

	// Validate outputs
	test_structure.RunTestStage(t, "validate", func() {
		vpcID := terraform.Output(t, terraformOptions, "vpc_id")
		subnetID := terraform.Output(t, terraformOptions, "subnet_id")
		keyName := terraform.Output(t, terraformOptions, "key_name")
		publicIP := terraform.Output(t, terraformOptions, "public_ip")
		publicDNS := terraform.Output(t, terraformOptions, "public_dns")

		// Basic validation
		if vpcID == "" {
			t.Fatal("Expected VPC ID to be set, but was empty")
		}
		if subnetID == "" {
			t.Fatal("Expected Subnet ID to be set, but was empty")
		}
		if keyName == "A Key pair was not created for this instance" {
			t.Fatal("Expected key pair to be created but it was not")
		}
		if publicIP == "Public IP not allocated" {
			t.Fatal("Expected public IP to be allocated but it was not")
		}
		if publicDNS == "Public DNS not allocated" {
			t.Fatal("Expected public DNS to be set but it was not")
		}
	})
}

// TestFeatureCombinations tests all of the module's features in various combinations
func TestFeatureCombinations(t *testing.T) {
	testDirs := []string{
		"dns-only",
		"s3-access",
		"full-force",
	}

	// Get the current AWS region from environment variable or use default
	awsRegion := os.Getenv("AWS_REGION")
	if awsRegion == "" {
		awsRegion = "us-east-1"
	}

	for _, dir := range testDirs {
		// Use a function to create a new variable scope for each iteration
		func(testDir string) {
			t.Run(testDir, func(t *testing.T) {
				t.Parallel()

				// Generate a unique project name for the test
				projectName := fmt.Sprintf("red-%s-%s", testDir, strings.ToLower(random.UniqueId()))

				// Make sure the test directory exists
				testDirPath := filepath.Join(".", testDir)
				if _, err := os.Stat(testDirPath); os.IsNotExist(err) {
					t.Skipf("Test directory %s does not exist, skipping", testDirPath)
					return
				}

				terraformOptions := &terraform.Options{
					TerraformDir: testDirPath,
					Vars: map[string]interface{}{
						"region":       awsRegion,
						"project_name": projectName,
					},
				}

				// Clean up resources in the end
				defer terraform.Destroy(t, terraformOptions)

				// Deploy using Terraform
				terraform.InitAndApply(t, terraformOptions)

				// Check if vpc_id output exists and is not empty
				vpcID := terraform.Output(t, terraformOptions, "vpc_id")
				if vpcID == "" {
					t.Fatal("Expected VPC ID to be set, but was empty")
				}
			})
		}(dir)
	}
}
