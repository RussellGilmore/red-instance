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

resource "aws_security_group" "allow_ssh" {
  vpc_id = var.create_vpc ? aws_vpc.main.id : var.vpc_id
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

resource "aws_instance" "red-instance" {
  ami                     = data.aws_ami.red_ami.id
  instance_type           = var.instance_type
  subnet_id               = var.create_vpc ? aws_subnet.public.id : var.subnet_id
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
  key_name                = aws_key_pair.red_key.key_name
  disable_api_termination = var.disable_api_termination
  disable_api_stop        = var.disable_api_stop

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

# Resource block for allocating an Elastic IP address (optional)
resource "aws_eip" "red_instance_eip" {
  count    = var.allocate_eip ? 1 : 0
  instance = aws_instance.red-instance.id

  tags = merge(
    {
      Name = "${var.project_name}-red-instance-eip"
    },
    var.additional_tags,
  )
}
