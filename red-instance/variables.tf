# Required Variables
variable "project_name" {
  description = "Set the project name."
  type        = string
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
}

# Optional EC2 Variables
variable "additional_tags" {
  description = "Additional tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_name" {
  description = "The name of the AMI to use for the instance"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240701.1"
}

variable "ami_owner" {
  description = "The owner of the AMI to use for the instance"
  type        = string
  default     = "099720109477"
}

variable "allocate_eip" {
  description = "Controls whether an Elastic IP should be allocated"
  type        = bool
  default     = true
}

variable "disable_api_termination" {
  description = "Controls whether API termination is disabled"
  type        = bool
  default     = false
}

variable "disable_api_stop" {
  description = "Controls whether API stop is disabled"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 30
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "user_data_script_path" {
  description = "The path to the user data script"
  type        = string
  default     = ""
}

# Optional Variables for VPC
variable "create_vpc" {
  description = "Controls whether networking resources should be created for public exposed server"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The ID of the VPC to use for the instance"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "The ID of the subnet to use for the instance"
  type        = string
  default     = ""
}
