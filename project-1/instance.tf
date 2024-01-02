resource "aws_instance" "webserver1" {
  ami                    = var.ec2_details.ami
  instance_type          = var.ec2_details.type
  vpc_security_group_ids = [aws_security_group.project-1-sg.id]
  subnet_id              = aws_subnet.subnet-1.id
  user_data              = base64encode(file("scripts/apache-v1.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = var.ec2_details.ami
  instance_type          = var.ec2_details.type
  vpc_security_group_ids = [aws_security_group.project-1-sg.id]
  subnet_id              = aws_subnet.subnet-2.id
  user_data              = base64encode(file("scripts/apache-v2.sh"))
}
