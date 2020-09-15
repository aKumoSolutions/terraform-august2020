resource "aws_sns_topic" "user_updates" {
  name = "${terraform.workspace}-example-topic"
}

resource "aws_sns_topic" "user_updates_e" {
  count = terraform.workspace == "second" ? 1 : 0
  name = "${terraform.workspace}-env-specific-topic-${count.index}"
}

resource "aws_sns_topic" "different_region" {
  provider = aws.ses
  name = "${terraform.workspace}-region-topic"
}

resource "aws_security_group" "first_sg" {
  name        = "${terraform.workspace}-test-sg"
  description = "test"
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}