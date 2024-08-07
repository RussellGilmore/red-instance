variable "project_name" {
  description = "Set the project name."
  type        = string
  default     = "red-test"
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
  default     = "us-east-1"
}

variable "create_resources" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
}
