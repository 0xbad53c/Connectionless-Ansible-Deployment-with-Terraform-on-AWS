// Create the security group
resource "aws_security_group" "ansible_instance" {
  name        = "${var.server_name}_security_group"
  description = "Security group created by Red Bastion"
  vpc_id      = data.aws_vpc.target_vpc.id
}

// no ingress required
// egress can be further restricted to only include egress
// ansible galaxy connections & AWS SSM API connections should be allowed
// The followign allows full egress, but only on ports 53 UDP, 80 & 443 TCP
resource "aws_vpc_security_group_egress_rule" "dns" {
  security_group_id = aws_security_group.ansible_instance.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 53
  ip_protocol = "udp"
  to_port     = 53
}

resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.ansible_instance.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.ansible_instance.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}
