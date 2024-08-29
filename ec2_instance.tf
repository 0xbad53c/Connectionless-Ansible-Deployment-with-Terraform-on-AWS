// Create EC2 ec2_instance instance
resource "aws_instance" "ec2_instance" {
  tags = {
    Name = "${var.server_name}"
  }

  root_block_device {
    delete_on_termination = var.delete_ebs_on_termination
    volume_size           = var.ebs_volume_size
    volume_type           = "gp2"

    tags = {
      Name = "${var.server_name}_ebs"
    }
  }

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ssh.key_name
  vpc_security_group_ids = [aws_security_group.ansible_instance.id]
  subnet_id              = data.aws_subnet.target_subnet.id
  iam_instance_profile   = aws_iam_instance_profile.ssm_s3.name // Enable SSM and s3 role for instance
  source_dest_check      = var.source_dest_check

  // optionally set a static IP
  private_ip = var.private_ip == "" ? null : var.private_ip

  // disable AWS metadata v1 (unauthenticated)
  // to improve security
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}
