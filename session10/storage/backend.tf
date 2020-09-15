terraform {
  backend "s3" {
    bucket         = "terraform-august-state"
    key            = "rds.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    workspace_key_prefix = "session10"
  }
}