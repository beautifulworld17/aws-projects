resource "aws_vpc" "project-1-vpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.project-1-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id                  = aws_vpc.project-1-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
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

resource "aws_security_group" "project-1-sg" {
  name        = "project-1-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.project-1-vpc.id

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-http-ssh"
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "project-1-bucket-bw"
}

resource "aws_instance" "webserver1" {
  ami                    = var.ec2_details.ami
  instance_type          = var.ec2_details.type
  vpc_security_group_ids = [aws_security_group.project-1-sg.id]
  subnet_id              = aws_subnet.subnet-1.id
  user_data              = base64encode(file("apache-v1.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = var.ec2_details.ami
  instance_type          = var.ec2_details.type
  vpc_security_group_ids = [aws_security_group.project-1-sg.id]
  subnet_id              = aws_subnet.subnet-2.id
  user_data              = base64encode(file("apache-v2.sh"))
}