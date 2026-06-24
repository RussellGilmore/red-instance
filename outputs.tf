output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.red-instance.id
}

output "vpc_id" {
  description = "The ID of the created VPC, or a note when an existing VPC was supplied."
  value       = var.create_vpc ? aws_vpc.main[0].id : "VPC was inherited from another module or resource"
}

output "subnet_id" {
  description = "The ID of the created subnet, or a note when an existing subnet was supplied."
  value       = var.create_vpc ? aws_subnet.public[0].id : "Subnet was inherited from another module or resource"
}

output "public_ip" {
  description = "The public IP address of the instance (EIP when allocated)."
  value       = var.allocate_eip ? aws_eip.red_instance_eip[0].public_ip : "Public IP not allocated"
}

output "public_dns" {
  description = "The public DNS name of the instance."
  value       = var.enable_public_dns ? aws_route53_record.red_instance_dns[0].fqdn : "Public DNS not allocated"
}

output "security_group_id" {
  description = "The ID of the instance security group."
  value       = aws_security_group.red_sg.id
}
