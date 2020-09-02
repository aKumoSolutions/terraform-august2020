data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "terraform-august-state"
    key    = "${var.session}/${var.env}/rds.tfstate"
    region = var.region
  }
}