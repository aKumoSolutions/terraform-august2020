resource "aws_launch_configuration" "webserver_lc" {
  name_prefix          = "${var.env}-webserver-lc-"
  image_id      = data.aws_ami.amazon_centos.id
  instance_type = var.instance_type

  root_block_device {
      delete_on_termination = true
  }
  
  lifecycle {
      create_before_destroy = true
  }

  user_data = data.template_file.user_data.rendered

  security_groups = [aws_security_group.instance_sg.id]
}

data "aws_ami" "amazon_centos" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }

  filter {
    name   = "product-code"
    values = ["*aw0evgkw8e5c1q413zgy5pjce*"]
  }
}

data "template_file" "user_data" {
    template = file("user-data.sh")
    vars = {
        env = var.env
    }
}

resource "aws_autoscaling_group" "webserver_asg" {
  name                      = aws_launch_configuration.webserver_lc.name
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 90
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false
  launch_configuration      = aws_launch_configuration.webserver_lc.name
  vpc_zone_identifier       = data.aws_subnet_ids.default_subnets.ids
  target_group_arns = [aws_lb_target_group.webserver_tg.arn]
  wait_for_elb_capacity = 1
  wait_for_capacity_timeout = "5m"
  lifecycle {
      create_before_destroy = true
  }
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_subnets" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_security_group" "instance_sg" {
  name = "${var.env}-instance-sg"
  description = "first sg created by tf"
  ingress {
    from_port   = var.webserver_port
    to_port     = var.webserver_port
    protocol    = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr
  }
}