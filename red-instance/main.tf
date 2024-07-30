# Provider configuration with default tags
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Orchestrator = "Terraform"
      Artifact     = "Red-Bucket"
      Project      = var.project_name
    }
  }
}
