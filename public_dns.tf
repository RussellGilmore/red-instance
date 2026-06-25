# This Terraform file creates a public DNS record for the red-instance EC2 instance.

# Data source block for getting the Route 53 zone
data "aws_route53_zone" "zone" {
  count = var.enable_public_dns ? 1 : 0
  name  = var.apex_domain
}

# Resource block for allocating an Elastic IP address (optional)
resource "aws_eip" "red_instance_eip" {
  count    = var.allocate_eip ? 1 : 0
  instance = aws_instance.red-instance.id

  tags = merge(
    local.tags,
    { Name = "${lower(var.instance_name)}-red-instance-eip" },
  )
}

# Resource block for creating a public DNS record
resource "aws_route53_record" "red_instance_dns" {
  count   = var.enable_public_dns ? 1 : 0
  zone_id = data.aws_route53_zone.zone[count.index].zone_id
  name    = var.dns_name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.red_instance_eip[count.index].public_ip]
}
