# Provider configuration with default tags
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Orchestrator = "Terraform"
      Artifact     = "Red-Instance"
      Project      = var.project_name
    }
  }
}

# Data source to get the Red Instance AMI
data "aws_ami" "red_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.ami_owner] # Canonical
}

# Dynamic block for creating ingress rules
resource "aws_security_group" "allow_ssh" {
  vpc_id = var.create_vpc ? aws_vpc.main[0].id : var.vpc_id
  name   = "${var.project_name}-ingress-sg"

  # Dynamic ingress rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.project_name}-Red-Instance"
    },
    var.additional_tags,
  )
}

# The Red Instance main resource block
resource "aws_instance" "red-instance" {
  ami                     = data.aws_ami.red_ami.id
  instance_type           = var.instance_type
  subnet_id               = var.create_vpc ? aws_subnet.public[0].id : var.subnet_id
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
  key_name                = aws_key_pair.red_key.key_name
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
    {
      Name = "${var.project_name}-Red-Instance"
    },
    var.additional_tags,
  )
}
