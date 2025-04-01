variable "project_name" {
  description = "Set the project name."
  type        = string
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
}

module "red-instance" {
  source = "../../red-instance"

  project_name = var.project_name
  region       = var.region

  # Custom AMI and instance configuration
  ami_name      = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-20250305"
  ami_owner     = "099720109477" # Canonical
  instance_type = "m6g.medium"
  volume_size   = 50

  # Basic networking setup
  create_vpc   = true
  allocate_eip = true

  # Enable DNS but no other optional features
  enable_public_dns = true
  apex_domain       = "rag-space.com"
  dns_name          = "red-instance-dns-test.rag-space.com"

  # Disable other optional features
  create_ec2_key_pair     = false
  enable_s3_bucket_policy = false

  # Only allow SSH access
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  additional_tags = {
    Environment = "Test-DNS-Only"
    TestCase    = "DNS-Feature"
  }
}

# Outputs to validate the configuration
output "vpc_id" {
  value = module.red-instance.vpc_id
}

output "subnet_id" {
  value = module.red-instance.subnet_id
}

output "public_ip" {
  value = module.red-instance.public_ip
}

output "public_dns" {
  value = module.red-instance.public_dns
}
