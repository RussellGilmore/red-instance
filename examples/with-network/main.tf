variable "project_name" {
  type    = string
  default = "red-instance-networked"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.region
}

module "network" {
  source = "git::https://github.com/RussellGilmore/red-network.git//red-network?ref=v2.0.0"

  project_name = var.project_name
  vpc_name     = "${var.project_name}-vpc"
  vpc_cidr     = "10.0.0.0/16"

  subnets = {
    public-1a = {
      name              = "${var.project_name}-public-1a"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "${var.region}a"
      type              = "public"
    }
  }
}

module "red_instance" {
  source = "../../"

  project_name  = var.project_name
  instance_name = "red-networked"

  create_vpc = false
  vpc_id     = module.network.vpc_id
  subnet_id  = module.network.public_subnet_ids[0]

  ingress_rules = [
    {
      description = "HTTPS from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  additional_tags = {
    Environment = "example"
  }
}

output "instance_id" {
  value = module.red_instance.instance_id
}
