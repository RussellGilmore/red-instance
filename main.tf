# Data source to get the Red Instance AMI
data "aws_ami" "red_ami" {
  most_recent        = true
  include_deprecated = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.ami_owner]
}

# Security group for the instance.
# Inbound access is via SSM Session Manager by default — only the ingress
# rules you explicitly pass are opened. Egress is open so SSM and package
# updates work.
# Justification: ingress is caller-controlled and intended for public services.
# trivy:ignore:AVD-AWS-0107
resource "aws_security_group" "red_sg" {
  vpc_id = var.create_vpc ? aws_vpc.main[0].id : var.vpc_id
  name   = "${lower(var.instance_name)}-ingress-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    { Name = "${lower(var.instance_name)}-ingress-sg" },
    var.instance_tags,
  )
}

# The Red Instance main resource block.
# Access is via SSM Session Manager (see the instance profile in ec2_iam.tf);
# no SSH key pair is created or attached.
resource "aws_instance" "red-instance" {
  ami                     = data.aws_ami.red_ami.id
  instance_type           = var.instance_type
  subnet_id               = var.create_vpc ? aws_subnet.public[0].id : var.subnet_id
  vpc_security_group_ids  = [aws_security_group.red_sg.id]
  disable_api_termination = var.disable_api_termination
  disable_api_stop        = var.disable_api_stop
  user_data               = var.user_data_script_path != "" ? file(var.user_data_script_path) : null
  iam_instance_profile    = aws_iam_instance_profile.red_instance_profile.name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.volume_size
    delete_on_termination = true
    iops                  = 3000
    throughput            = 125
    encrypted             = true
  }

  tags = merge(
    local.tags,
    { Name = var.instance_name },
    var.instance_tags,
  )
}
