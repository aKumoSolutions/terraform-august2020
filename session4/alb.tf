resource "aws_lb" "webserver_alb" {
  name               = "${var.env}-webserver-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webserver_sg.id]
  subnets            = data.aws_subnet_ids.default_subnets.ids
}

resource "aws_security_group" "webserver_sg" {
  name = "${var.env}-webserver-sg"
  description = "first sg created by tf"
  ingress {
    from_port   = var.webserver_port
    to_port     = var.webserver_port
    protocol    = "tcp"
    cidr_blocks = var.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr
  }
}

resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.webserver_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Page not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "webserver_lr" {
  listener_arn = aws_lb_listener.webserver_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_lb_target_group" "webserver_tg" {
  name     = "${var.env}-webserver-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id
  health_check {
      path = "/"
      protocol = "HTTP"
      interval = 10
      healthy_threshold = 2
      unhealthy_threshold = 3
      matcher = "200"
  }
}