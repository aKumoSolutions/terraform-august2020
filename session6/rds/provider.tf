terraform {
  required_version = ">= 0.12, < 0.13"
  required_providers {
    aws    = "~> 3.1"
    random = "~> 2.3"
  }
}

provider "aws" {
  region = "us-east-1"
}