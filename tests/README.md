# Red Instance Module Tests

This directory contains tests for the Red Instance Terraform module.

## Test Cases

The tests are organized into different directories, each testing a different
aspect or configuration of the module:

1. **dns-only** - Tests with only DNS features enabled
2. **s3-access** - Tests with only S3 bucket access enabled
3. **full-features** - Tests with all features enabled and customized

## Running Tests

To run individual test cases with Terraform directly:

```bash
cd tests/<test-case-directory>
terraform init
terraform apply
# Verify outputs
terraform destroy
```

To run the Go tests which test all feature combinations:

```bash
cd tests
go test -v
```

To run a specific test:

```bash
cd tests
go test -v -run TestDNSOnlyFeature
```

## Test Cleanup

The Go tests will automatically clean up resources after testing, but if you run
Terraform commands directly, remember to run `terraform destroy` when you're
done.

## Environment Variables

The tests use the following environment variables:

-   `AWS_REGION`: AWS region to deploy resources to (default: us-east-1)
-   `AWS_ACCESS_KEY_ID`: AWS access key
-   `AWS_SECRET_ACCESS_KEY`: AWS secret key
