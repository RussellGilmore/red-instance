output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "subnet_id" {
  value       = aws_subnet.public.id
  description = "The ID of the public subnet"
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
