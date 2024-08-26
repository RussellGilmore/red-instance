# Red Instance

## [![Red EC2 Module](https://github.com/RussellGilmore/red-instance/actions/workflows/module-test.yml/badge.svg?branch=main)](https://github.com/RussellGilmore/red-instance/actions/workflows/module-test.yml)

A EC2 module module designed to be practical for casual use.

## Features

1. Gives to ability for create a EC2 Instance
2. Optionally Create all network infrastructure needed for public access
3. Pass custom user data into instance creation
4. SSM and S3 Access Permissions for access and ease of use
5. Creates Key for SSH Access
6. Dynamically Create Ingress Security Rules
7. Provision a Public DNS record for the Red Instance

Contains a useful scripts for setting up AWS CLI for both SUSE and Ubuntu Linux.

```bash
#!/bin/bash

# Install AWS CLI v2 on SUSE and Ubuntu Linux (x86_64 and arm)

# Check the Linux distribution
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  if [[ $ID == "ubuntu" ]]; then
    # Update Ubuntu and install unzip
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y unzip
  elif [[ $ID == "suse" ]]; then
    # Update SUSE and install unzip
    sudo zypper refresh
    sudo zypper update -y
    sudo zypper install -y unzip
  else
    echo "Unsupported Linux distribution: $ID"
    exit 1
  fi
else
  echo "Unable to determine Linux distribution"
  exit 1
fi

# Check the architecture
if [[ $(uname -m) == "x86_64" ]]; then
  # Install AWS CLI for x86_64
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
else
  # Install AWS CLI for arm
  curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
fi
```

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
| [aws_eip.red_instance_eip](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/eip) | resource |
| [aws_iam_instance_profile.red_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.red_role](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ssm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.red-instance](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/instance) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.red_key](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/key_pair) | resource |
| [aws_route53_record.red_instance_dns](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/route53_record) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/route_table_association) | resource |
| [aws_security_group.allow_ssh](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/security_group) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/vpc) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.red_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.red_ami](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/data-sources/ami) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to apply to the resources | `map(string)` | `{}` | no |
| <a name="input_allocate_eip"></a> [allocate\_eip](#input\_allocate\_eip) | Controls whether an Elastic IP should be allocated | `bool` | `true` | no |
| <a name="input_ami_name"></a> [ami\_name](#input\_ami\_name) | The name of the AMI to use for the instance | `string` | `"ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240701.1"` | no |
| <a name="input_ami_owner"></a> [ami\_owner](#input\_ami\_owner) | The owner of the AMI to use for the instance | `string` | `"099720109477"` | no |
| <a name="input_apex_domain"></a> [apex\_domain](#input\_apex\_domain) | The apex domain to use for the public DNS record | `string` | `""` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Controls whether networking resources should be created for public exposed server | `bool` | `true` | no |
| <a name="input_disable_api_stop"></a> [disable\_api\_stop](#input\_disable\_api\_stop) | Controls whether API stop is disabled | `bool` | `false` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | Controls whether API termination is disabled | `bool` | `false` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | The DNS name to use for the public DNS record | `string` | `""` | no |
| <a name="input_enable_public_dns"></a> [enable\_public\_dns](#input\_enable\_public\_dns) | Controls whether a public DNS record should be created | `bool` | `false` | no |
| <a name="input_enable_s3_bucket_policy"></a> [enable\_s3\_bucket\_policy](#input\_enable\_s3\_bucket\_policy) | Controls whether an S3 bucket policy should be attached to the instance role | `bool` | `false` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 22,<br>    "protocol": "tcp",<br>    "to_port": 22<br>  }<br>]</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for the instance | `string` | `"t2.micro"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Set the project name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Set the appropriate AWS region. | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 bucket to use for the instance | `string` | `""` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to use for the instance | `string` | `""` | no |
| <a name="input_user_data_script_path"></a> [user\_data\_script\_path](#input\_user\_data\_script\_path) | The path to the user data script | `string` | `""` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the root volume in GB | `number` | `30` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to use for the instance | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_fingerprint"></a> [key\_fingerprint](#output\_key\_fingerprint) | The fingerprint of the key pair |
| <a name="output_key_name"></a> [key\_name](#output\_key\_name) | The name of the key pair |
| <a name="output_private_key_path"></a> [private\_key\_path](#output\_private\_key\_path) | The path to the private key file |
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | The public DNS name of the instance |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | The public IP address of the instance |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | The ID of the created subnet |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the created VPC |
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
