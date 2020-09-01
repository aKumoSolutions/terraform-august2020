resource "aws_instance" "first_ec2" {
  ami           = data.aws_ami.amazon_centos.image_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.terraform.id
  root_block_device {
    delete_on_termination = true
  }

  # user_data = data.template_file.user_data.rendered

  vpc_security_group_ids = [aws_security_group.first_sg.id]

  tags = {
    Name        = format("%s-webserver-changed-2", var.env),
    Name2       = "${var.env}-webserver"
    Environment = var.env
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "centos"
      host        = self.public_ip
      private_key = file("/home/centos/.ssh/id_rsa")
    }
    source = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "centos"
      host        = self.public_ip
      private_key = file("/home/centos/.ssh/id_rsa")
    }
    inline = [
      "sudo yum install httpd -y",
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo systemctl start httpd"
    ]
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

resource "aws_key_pair" "terraform" {
  key_name   = "terraform"
  public_key = file("/home/centos/.ssh/id_rsa.pub")
}

resource "aws_security_group" "first_sg" {
  name        = "${var.env}-webserver-sg"
  description = "first sg created by tf"
  ingress {
    from_port   = var.webserver_port
    to_port     = var.webserver_port
    protocol    = "tcp"
    cidr_blocks = var.cidr
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

data "template_file" "user_data" {
  template = file("user-data.sh")
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

