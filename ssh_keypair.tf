// Generate private key in case we want to authenticate via SSH (should not happen)
// E.g. as backup in case amazon-ssm-agent crashes
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// write the key to local disk. Can be omitted 
resource "local_file" "foo" {
  content  = tls_private_key.ssh.private_key_pem
  filename = "${var.ssh_key_local_directory}/${var.server_name}.pem"
}

// Add public key to AWS
resource "aws_key_pair" "ssh" {
  key_name   = "ssh_${var.server_name}"
  public_key = tls_private_key.ssh.public_key_openssh
}
