output "vpc_id" {
  value       = var.create_vpc ? aws_vpc.main[0].id : "VPC was inherited from another module or resource"
  description = "The ID of the created VPC"
}

output "subnet_id" {
  value       = var.create_vpc ? aws_subnet.public[0].id : "Subnet was inherited from another module or resource"
  description = "The ID of the created subnet"
}

output "key_name" {
  value       = aws_key_pair.red_key.key_name
  description = "The name of the key pair"
}

output "key_fingerprint" {
  value       = aws_key_pair.red_key.fingerprint
  description = "The fingerprint of the key pair"
}

output "private_key_path" {
  value       = local_file.private_key_pem.filename
  description = "The path to the private key file"
}

output "public_ip" {
  value       = var.allocate_eip ? aws_eip.red_instance_eip[0].public_ip : "Public IP not allocated"
  description = "The public IP address of the instance"
}

output "public_dns" {
  value       = var.enable_public_dns ? aws_route53_record.red_instance_dns[0].fqdn : "Public DNS not allocated"
  description = "The public DNS name of the instance"
}
