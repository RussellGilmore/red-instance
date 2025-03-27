# Creates a key pair for the EC2 instance and saves the private key to a file

# Create a key pair for the EC2 instance
resource "aws_key_pair" "red_key" {
  count      = var.create_ec2_key_pair ? 1 : 0
  key_name   = "${lower(var.project_name)}-red-instance-key"
  public_key = tls_private_key.red_private_key[count.index].public_key_openssh

  tags = merge(
    {
      Name = "${lower(var.project_name)}-red-instance-key"
    },
    var.additional_tags,
  )
}

# Create a private key file
resource "tls_private_key" "red_private_key" {
  count     = var.create_ec2_key_pair ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key to a file
resource "local_file" "red_private_key_file" {
  count           = var.create_ec2_key_pair ? 1 : 0
  filename        = "${lower(var.project_name)}-ec2-key.pem"
  content         = tls_private_key.red_private_key[count.index].private_key_pem
  file_permission = "0400"
}
