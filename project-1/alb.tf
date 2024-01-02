resource "aws_lb" "lb" {
  name               = "project-1-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.project-1-sg.id]
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  tags = {
    name = "webserver"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "project-1-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project-1-vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "lb-tga-1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "lb-tga-2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

output "loadbalancerdns" {
  value = aws_lb.lb.dns_name
}