terraform {
  backend "s3" {
    bucket = "terraform-august-state"
    key    = "session5/ec2.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-locks"
  }
}