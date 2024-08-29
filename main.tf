// fetch the vpc id based on the vpc name
data "aws_vpc" "target_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

// fetch the subnet id based on the subnet name
data "aws_subnet" "target_subnet" {
  vpc_id = data.aws_vpc.target_vpc.id

  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}