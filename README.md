# Red Instance

## [![Red EC2 Module](https://github.com/RussellGilmore/red-instance/actions/workflows/module-test.yml/badge.svg?branch=main)](https://github.com/RussellGilmore/red-instance/actions/workflows/module-test.yml)

A practical EC2 module — **SSM-only by design**. No SSH keys are created,
stored, or attached; you reach the instance through AWS Session Manager.

**Requirements:**

1. Terraform >= 1.15.0
2. Trivy >= 0.68.2

Trivy can be installed via Homebrew on macOS with the command:

```bash
brew install aquasecurity/trivy/trivy
```

## Security posture

-   **No SSH key pair** — access is via SSM Session Manager. No private key is
    generated, written to disk, or stored in Terraform state.
-   IMDSv2 required; root EBS volume encrypted
-   Instance role limited to `AmazonSSMManagedInstanceCore` plus an optional
    bucket-scoped S3 policy
-   You open only the ingress ports you serve — examples open 80/443, never 22
-   Scanned with Trivy and gitleaks; integration-tested with Terratest

## Features

1. Gives to ability for create a EC2 Instance
2. EC2 is already setup for SSM Agent to be installed
3. Dynamically Create Ingress Security Rules
4. Optionally create all network infrastructure needed for public access
5. Optionally create public DNS record for the Red Instance
6. Optionally pass user data into instance creation
7. Optionally enabled S3 Bucket IAM Role Access

## Usage

Self-contained (creates a minimal public VPC) — see
[`examples/complete`](./examples/complete):

```hcl
provider "aws" {
  region = "us-east-1"
}

module "instance" {
  source = "RussellGilmore/red-instance/aws"

  project_name  = "my-project"
  instance_name = "web"

  ingress_rules = [{
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}
```

Connect with: `aws ssm start-session --target <instance_id>`.

To place the instance in an existing network (e.g. red-network), set
`create_vpc = false` and pass `vpc_id`/`subnet_id` — see
[`examples/with-network`](./examples/with-network).

<!-- prettier-ignore-start -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.47.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_eip.red_instance_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.red_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.red_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.red_ssm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.red-instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route53_record.red_instance_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.red_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.red_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to apply to all resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_allocate_eip"></a> [allocate\_eip](#input\_allocate\_eip) | Controls whether an Elastic IP should be allocated. | `bool` | `true` | no |
| <a name="input_ami_name"></a> [ami\_name](#input\_ami\_name) | The name (or name pattern) of the AMI to use for the instance. | `string` | `"ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-20250610"` | no |
| <a name="input_ami_owner"></a> [ami\_owner](#input\_ami\_owner) | The owner account ID of the AMI. | `string` | `"099720109477"` | no |
| <a name="input_apex_domain"></a> [apex\_domain](#input\_apex\_domain) | Apex domain whose hosted zone holds the DNS record. | `string` | `""` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone for the created subnet. Leave empty for default placement. | `string` | `""` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Create a minimal public VPC (single subnet + IGW) for the instance. Set false to place the instance in an existing VPC via vpc\_id/subnet\_id. | `bool` | `true` | no |
| <a name="input_disable_api_stop"></a> [disable\_api\_stop](#input\_disable\_api\_stop) | Controls whether API stop is disabled. | `bool` | `false` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | Controls whether API termination is disabled. | `bool` | `false` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | FQDN for the public DNS record. | `string` | `""` | no |
| <a name="input_enable_public_dns"></a> [enable\_public\_dns](#input\_enable\_public\_dns) | Create a public Route53 A record pointing at the instance's EIP. | `bool` | `false` | no |
| <a name="input_enable_s3_bucket_policy"></a> [enable\_s3\_bucket\_policy](#input\_enable\_s3\_bucket\_policy) | Attach an S3 access policy (scoped to s3\_bucket\_name) to the instance role. | `bool` | `false` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules for the instance security group. Access is via SSM Session Manager by default; only open inbound ports you actually serve (e.g. 80/443). | <pre>list(object({<br/>    description = string<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the instance. | `string` | n/a | yes |
| <a name="input_instance_tags"></a> [instance\_tags](#input\_instance\_tags) | Tags to apply only to the EC2 instance resource. | `map(string)` | `{}` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for the instance. | `string` | `"t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name used for naming and the Project tag. | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket the instance role may access. | `string` | `""` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of an existing subnet to use when create\_vpc is false. | `string` | `""` | no |
| <a name="input_user_data_script_path"></a> [user\_data\_script\_path](#input\_user\_data\_script\_path) | Path to a user data script to run on first boot. | `string` | `""` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the root volume in GB. | `number` | `30` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of an existing VPC to use when create\_vpc is false. | `string` | `""` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The ID of the EC2 instance. |
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | The public DNS name of the instance. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | The public IP address of the instance (EIP when allocated). |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the instance security group. |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | The ID of the created subnet, or a note when an existing subnet was supplied. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the created VPC, or a note when an existing VPC was supplied. |
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
