locals {
  tags = merge(
    {
      Orchestrator = "Terraform"
      Artifact     = "Red-Instance"
      Project      = var.project_name
    },
    var.additional_tags
  )
}
