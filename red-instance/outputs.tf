output "vpc_id" {
  value     = aws_vpc.main[0].id
}

output "subnet_id" {
  value     = aws_subnet.public.id
}
