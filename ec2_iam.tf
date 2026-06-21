# This file creates the IAM role and instance profile for the Red Instance.

# The role has a trust policy that allows EC2 instances to assume the role.
resource "aws_iam_instance_profile" "red_instance_profile" {
  name = "${lower(var.instance_name)}-red-instance-profile"
  role = aws_iam_role.red_role.name
}

# Create the IAM role for the Red Instance
resource "aws_iam_role" "red_role" {
  name               = "${lower(var.instance_name)}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach the AmazonSSMManagedInstanceCore policy to the role. All Red Instances will have SSM access.
resource "aws_iam_role_policy_attachment" "red_ssm_policy_attachment" {
  role       = aws_iam_role.red_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Role policy for S3 bucket access
resource "aws_iam_role_policy" "s3_bucket_policy" {
  name = "${lower(var.instance_name)}-s3-bucket-policy"
  role = aws_iam_role.red_role.name

  count = var.enable_s3_bucket_policy ? 1 : 0

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_name}",
        "arn:aws:s3:::${var.s3_bucket_name}/*"
      ]
    }
  ]
}
EOF
}
