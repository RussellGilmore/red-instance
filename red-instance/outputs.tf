output "vpc_id" {
  value     = aws_vpc.main[0].id
  condition = var.create_resources
}

output "subnet_id" {
  value     = aws_subnet.public[0].id
  condition = var.create_resources
}
