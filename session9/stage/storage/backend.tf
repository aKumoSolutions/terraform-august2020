terraform {
  backend "s3" {
    bucket         = "terraform-august-state"
    key            = "session9/stage/rds.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
  }
}