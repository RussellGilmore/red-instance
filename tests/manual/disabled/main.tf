# This file is used to test with features sets disabled.

module "red-instance" {
  source = "../../red-instance"

  project_name = "Red-Instance-Has-No-VPC"
  region       = "us-east-1"
  ingress_rules = [
    {
      description = "Allow SSH access from anywhere"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTP access from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  create_ec2_key_pair   = false
  create_vpc            = false
  user_data_script_path = "../../scripts/init.sh"
  vpc_id                = "vpc-98a359e0"
  subnet_id             = "subnet-2a3dea61"
  additional_tags = {
    Environment = "Has-No-VPC"
  }
}


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
