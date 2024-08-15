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
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.red-instance](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/instance) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.red_key](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/key_pair) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/route_table_association) | resource |
| [aws_security_group.allow_ssh](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/security_group) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/vpc) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.red_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.red_ami](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to apply to the resources | `map(string)` | `{}` | no |
| <a name="input_ami_name"></a> [ami\_name](#input\_ami\_name) | The name of the AMI to use for the instance | `string` | `"ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240701.1"` | no |
| <a name="input_ami_owner"></a> [ami\_owner](#input\_ami\_owner) | The owner of the AMI to use for the instance | `string` | `"099720109477"` | no |
| <a name="input_create_resources"></a> [create\_resources](#input\_create\_resources) | Controls whether resources should be created | `bool` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for the instance | `string` | `"t2.micro"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Set the project name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Set the appropriate AWS region. | `string` | n/a | yes |
| <a name="input_sg_name"></a> [sg\_name](#input\_sg\_name) | The name of the security group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_fingerprint"></a> [key\_fingerprint](#output\_key\_fingerprint) | n/a |
| <a name="output_key_name"></a> [key\_name](#output\_key\_name) | n/a |
| <a name="output_private_key_path"></a> [private\_key\_path](#output\_private\_key\_path) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
