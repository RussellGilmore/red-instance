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

}
