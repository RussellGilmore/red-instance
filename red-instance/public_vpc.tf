# This file creates a VPC, a public subnet, an internet gateway, a route table, and associates the route table with the subnet.

# Data source to get available AZs that support the instance type
data "aws_availability_zones" "available" {
  count = var.create_vpc ? 1 : 0
  state = "available"

  # Filter to exclude AZs that typically don't support ARM instances
  exclude_names = ["us-east-1e"] # Add other problematic AZs as needed
}

# The resources are created conditionally based on the value of the create_vpc variable.
# Justification: This is for development purposes, Flow Logs and other features are not required for a red instance.
# trivy:ignore:AVD-AWS-0178
resource "aws_vpc" "main" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name    = "${lower(var.instance_name)}-red-instance-vpc",
      Project = var.project_name
    },
    var.additional_tags,
  )
}

# Create a public subnet with explicit AZ
# Justification: This is a public subnet for the red instance
# trivy:ignore:AVD-AWS-0164
resource "aws_subnet" "public" {
  count                   = var.create_vpc ? 1 : 0
  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  # Use the first available AZ that supports ARM instances
  availability_zone = data.aws_availability_zones.available[0].names[0]

  tags = merge(
    {
      Name    = "${lower(var.instance_name)}-red-instance-public-subnet"
      Project = var.project_name
    },
    var.additional_tags,
  )
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  tags = merge(
    {
      Name    = "${lower(var.instance_name)}-red-instance-igw",
      Project = var.project_name
    },
    var.additional_tags,
  )
}

# Create a route table and associate it with the public subnet
resource "aws_route_table" "public" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = merge(
    {
      Name    = "${lower(var.instance_name)}-red-instance-public-route-table",
      Project = var.project_name
    },
    var.additional_tags,
  )
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public" {
  count          = var.create_vpc ? 1 : 0
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.public[0].id
}
