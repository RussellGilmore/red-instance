####################################################################################################
# Required Variables
variable "project_name" {
  description = "Set the project name."
  type        = string
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
}

####################################################################################################
# Optional Red Instance Variables
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

####################################################################################################
# Optional Variables for Red Instance Features
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

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to use for the instance"
  type        = string
  default     = ""
}

variable "enable_s3_bucket_policy" {
  description = "Controls whether an S3 bucket policy should be attached to the instance role"
  type        = bool
  default     = false
}

variable "enable_public_dns" {
  description = "Controls whether a public DNS record should be created"
  type        = bool
  default     = false
}

variable "apex_domain" {
  description = "The apex domain to use for the public DNS record"
  type        = string
  default     = ""
}

variable "dns_name" {
  description = "The DNS name to use for the public DNS record"
  type        = string
  default     = ""
}
