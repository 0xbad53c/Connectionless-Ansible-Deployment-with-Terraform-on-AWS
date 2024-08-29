locals {
  iam_role_base = lower(replace("${var.server_name}", "_", "-")) // replace _ with - and lowercase all to be accepted as bucket name
}

// Create SSM Role that allows ansible to configure the machine
// EC2 instance should be able to assume the role
resource "aws_iam_role" "ssm_s3" {
  name = substr("${local.iam_role_base}_ssm_s3_role", 0, 63) // name can only be 64 chars max

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

// attach default recommended SSM policy to new role
// Instance with this role is now onboarded to SSM
resource "aws_iam_role_policy_attachment" "ssm_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_s3.name
}

// also allow access to s3 bucket that shares files with instance
resource "aws_iam_policy" "s3_bucket_policy" {
  name = "${local.iam_role_base}_s3_bucket_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:Get*", "s3:List*", "s3:PutObject"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${local.bucket_name}/*"
      }
    ]
  })
}

// attach policy to same role
resource "aws_iam_role_policy_attachment" "s3_role_policy" {
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
  role       = aws_iam_role.ssm_s3.name
}

// create profile to use to assign role to ec2 instance
resource "aws_iam_instance_profile" "ssm_s3" {
  name = "${local.iam_role_base}_ssm_profile"
  role = aws_iam_role.ssm_s3.name
}
