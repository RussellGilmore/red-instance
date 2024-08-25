module "red-instance" {
  source = "../../red-instance"

  project_name = "Red-Instance-Has-VPC"
  region       = "us-east-1"
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
  user_data_script_path   = "script.sh"
  enable_s3_bucket_policy = true
  s3_bucket_name          = "red-drop-s3"
  additional_tags = {
    Environment = "Has-VPC"
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
