terraform {
  backend "s3" {
    bucket         = "terraform-august-state"
    key            = "session8/dev/ec2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
  }
}