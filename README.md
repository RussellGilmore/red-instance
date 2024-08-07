# Red Instance

## [![Red EC2 Module](https://github.com/RussellGilmore/red-instance/actions/workflows/module-test.yml/badge.svg?branch=main)](https://github.com/RussellGilmore/red-instance/actions/workflows/module-test.yml)

A EC2 module module designed to be practical for casual use.

<!-- prettier-ignore-start -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.red-instance](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/instance) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/internet_gateway) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/route_table_association) | resource |
| [aws_security_group.allow_ssh](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/security_group) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | The AMI to use for the instance | `string` | n/a | yes |
| <a name="input_create_resources"></a> [create\_resources](#input\_create\_resources) | Controls whether resources should be created | `bool` | `true` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Set the project name. | `string` | `"red-test"` | no |
| <a name="input_region"></a> [region](#input\_region) | Set the appropriate AWS region. | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
