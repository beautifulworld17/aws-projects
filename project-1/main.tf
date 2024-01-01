resource "aws_vpc" "project-1-vpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.project-1-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.project-1-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-2"
  }
}

resource "aws_internet_gateway" "project-1-gw" {
  vpc_id = aws_vpc.project-1-vpc.id
}

resource "aws_route_table" "project-1-RT" {
  vpc_id = aws_vpc.project-1-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-1-gw.id
  }
}

resource "aws_route_table_association" "rta-1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.project-1-RT.id
}

resource "aws_route_table_association" "rta-2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.project-1-RT.id
}