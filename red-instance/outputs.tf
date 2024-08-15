output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "key_name" {
  value = aws_key_pair.red_key.key_name
}

output "key_fingerprint" {
  value = aws_key_pair.red_key.fingerprint
}

output "private_key_path" {
  value = local_file.private_key_pem.filename
}
