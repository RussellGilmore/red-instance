variable "project_name" {
  description = "Set the project name."
  type        = string
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
}

module "red-instance" {
  source = "../../red-instance"

  project_name  = var.project_name
  region        = var.region
  instance_name = var.instance_name

  # Custom AMI and instance configuration
  instance_type = "m6g.medium"
  volume_size   = 50

  # Enable all optional features
  create_vpc              = true
  allocate_eip            = true
  create_ec2_key_pair     = true
  enable_public_dns       = true
  apex_domain             = "rag-space.com"
  dns_name                = "full-force.rag-space.com"
  enable_s3_bucket_policy = true
  s3_bucket_name          = "red-infra-test-s3"

  # User data script
  user_data_script_path = "../../scripts/init.sh"

  # Comprehensive security group rules
  ingress_rules = [
    {
      description = "Allow SSH access from the VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      description = "Allow HTTP access from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS access from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow custom application traffic"
      from_port   = 8000
      to_port     = 9000
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]

  additional_tags = {
    Environment = "Test-All-Features"
    TestCase    = "Full-Feature-Test"
    Department  = "Engineering"
    CostCenter  = "TestLab"
  }
}

# Outputs to validate the configuration
output "vpc_id" {
  value = module.red-instance.vpc_id
}

output "subnet_id" {
  value = module.red-instance.subnet_id
}

output "key_name" {
  value = module.red-instance.key_name
}

output "key_fingerprint" {
  value = module.red-instance.key_fingerprint
}

output "private_key_path" {
  value = module.red-instance.private_key_path
}

output "public_ip" {
  value = module.red-instance.public_ip
}

output "public_dns" {
  value = module.red-instance.public_dns
}
