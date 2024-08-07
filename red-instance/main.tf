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

resource "aws_security_group" "allow_ssh" {
  count  = var.create_resources ? 1 : 0
  vpc_id = aws_vpc.main[0].id

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

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_instance" "red-instance" {
  count           = var.create_resources ? 1 : 0
  ami             = ""
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public[0].id
  security_groups = [aws_security_group.allow_ssh[0].name]

  tags = {
    Name = "web-instance"
  }
}
