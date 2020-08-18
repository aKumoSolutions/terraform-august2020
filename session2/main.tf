resource "aws_instance" "first_ec2" {
  ami           = "ami-0affd4508a5d2481b"
  instance_type = "t2.micro"

  root_block_device {
      delete_on_termination = true
  }

  tags = {
      Name = "UpdatedName2"
  }
}

resource "random_pet" "my_pet" {

}

terraform {
  required_version = ">= 0.12, < 0.13"
  required_providers {
    aws = "~> 3.1"
    random = "~> 2.3"
  }
}

provider "aws" {
    region = "us-east-1"
}
