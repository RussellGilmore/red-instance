module "red-instance" {
  source = "../../red-instance"

  project_name = "Red-Instance-DNS-Only"
  region       = "us-east-1"

  # Basic networking setup
  create_vpc   = true
  allocate_eip = true

  # Enable DNS but no other optional features
  enable_public_dns = true
  apex_domain       = "example.com"
  dns_name          = "red-instance-test.example.com"

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
