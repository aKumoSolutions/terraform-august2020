terraform {
  backend "s3" {
    bucket         = "terraform-august-state"
    key            = "session9/dev/rds.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
  }
}