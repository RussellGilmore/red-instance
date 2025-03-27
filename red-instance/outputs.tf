output "key_name" {
  value       = var.create_ec2_key_pair ? aws_key_pair.red_key[0].key_name : "A Key pair was not created for this instance"
  description = "The name of the key pair"
}

output "key_fingerprint" {
  value       = var.create_ec2_key_pair ? aws_key_pair.red_key[0].fingerprint : "A Key pair was not created for this instance"
  description = "The fingerprint of the key pair"
}

output "private_key_path" {
  value       = var.create_ec2_key_pair ? local_file.red_private_key_file[0].filename : "A Key pair was not created for this instance"
  description = "The path to the private key file"
}

output "vpc_id" {
  value       = var.create_vpc ? aws_vpc.main[0].id : "VPC was inherited from another module or resource"
  description = "The ID of the created VPC"
}

output "subnet_id" {
  value       = var.create_vpc ? aws_subnet.public[0].id : "Subnet was inherited from another module or resource"
  description = "The ID of the created subnet"
}

output "public_ip" {
  value       = var.allocate_eip ? aws_eip.red_instance_eip[0].public_ip : "Public IP not allocated"
  description = "The public IP address of the instance"
}

output "public_dns" {
  value       = var.enable_public_dns ? aws_route53_record.red_instance_dns[0].fqdn : "Public DNS not allocated"
  description = "The public DNS name of the instance"
}
