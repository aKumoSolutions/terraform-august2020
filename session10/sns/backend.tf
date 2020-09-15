terraform {
  backend "s3" {
    bucket         = "terraform-august-state"
    key            = "example/sns.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    workspace_key_prefix = "session10"
  }
}