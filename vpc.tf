resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "my_vpc_nvirginia" {
  cidr_block = "10.0.0.0/16"
  provider   = aws.nvirginia
}