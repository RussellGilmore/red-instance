resource "aws_key_pair" "red_key" {
  key_name   = "${var.project_name}-red-instance-key"
  public_key = tls_private_key.red_private_key.public_key_openssh

  tags = merge(
    {
      Name = "${var.project_name}-red-instance-key"
    },
    var.additional_tags,
  )
}

resource "tls_private_key" "red_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  filename        = "${var.project_name}-ec2-key.pem"
  content         = tls_private_key.red_private_key.private_key_pem
  file_permission = "0400"
}
