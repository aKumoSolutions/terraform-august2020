resource "aws_instance" "first_ec2" {
  ami           = data.aws_ami.amazon_centos.image_id
  instance_type = var.instance_type
  root_block_device {
    delete_on_termination = true
  }

  user_data = data.template_file.user_data.rendered

  vpc_security_group_ids = [aws_security_group.first_sg.id]

  tags = {
    Name        = format("%s-webserver", var.env),
    Name2       = "${var.env}-webserver"
    Environment = var.env
  }
}

resource "null_resource" "tag_volumes" {
  triggers = {
    val = aws_instance.first_ec2.tags["Name"]
  }
  provisioner "local-exec" {
    command = <<EOF
aws ec2 create-tags \
  --resources ${aws_instance.first_ec2.root_block_device.0.volume_id} \
  --region us-east-1 \
  --tags \
    Key=Name,Value=${aws_instance.first_ec2.tags["Name"]} \
    Key=sdfds,Value=sdfds
EOF
  }
}

resource "aws_security_group" "first_sg" {
  name        = "${var.env}-webserver-sg"
  description = "first sg created by tf"
  ingress {
    from_port   = local.webserver_port
    to_port     = local.webserver_port
    protocol    = local.protocol
    cidr_blocks = var.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
  vars = {
    env = var.env
    db  = data.terraform_remote_state.rds.outputs.db_address
  }
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

