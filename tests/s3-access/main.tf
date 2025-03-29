module "red-instance" {
  source = "../../red-instance"

  project_name = "Red-Instance-S3-Access"
  region       = "us-east-1"

  # Basic networking setup
  create_vpc   = true
  allocate_eip = true

  # Enable S3 bucket access
  enable_s3_bucket_policy = true
  s3_bucket_name          = "test-red-instance-bucket"

  # Disable other optional features
  enable_public_dns   = false
  create_ec2_key_pair = false

  # Add basic security group rules
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  additional_tags = {
    Environment = "Test-S3-Access"
    TestCase    = "S3-Access-Feature"
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

# We should get a message indicating that DNS isn't enabled
output "public_dns" {
  value = module.red-instance.public_dns
}
