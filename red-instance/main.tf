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
  vpc_id = aws_vpc.main.id

  name = var.sg_name

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name     = "${var.project_name}-Red-Instance"
      Function = var.sg_name
    },
    var.additional_tags,
  )
}

resource "aws_instance" "red-instance" {
  ami                         = data.aws_ami.red_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.red_key.key_name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(
    {
      Name = "${var.project_name}-Red-Instance"
    },
    var.additional_tags,
  )
}
