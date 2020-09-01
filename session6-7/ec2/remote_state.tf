data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "terraform-august-state"
    key    = "session6/rds.tfstate"
    region = "us-east-1"
  }
}