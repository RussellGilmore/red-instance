# variable "project_name" {
#   description = "Set the project name."
#   type        = string
# }

# variable "region" {
#   description = "Set the appropriate AWS region."
#   type        = string
# }

module "red-instance" {
  source = "../red-instance"

  project_name     = "Red-Instance"
  region           = "us-east-1"
  create_resources = true
  sg_name          = "SSH Access"
  additional_tags = {
    Environment = "Dev"
  }
}
