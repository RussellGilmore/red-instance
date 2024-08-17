variable "project_name" {
  description = "Set the project name."
  type        = string
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
}

module "red-instance" {
  source = "../red-instance"

  project_name = var.project_name
  region       = var.region
  sg_name      = "ssh-access"
  additional_tags = {
    Environment = "Dev"
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
