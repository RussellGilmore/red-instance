# Required Variables
variable "project_name" {
  description = "Set the project name."
  type        = string
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
}

# Optional Variables
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

variable "create_public_networking" {
  description = "Controls whether networking resources should be created"
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
