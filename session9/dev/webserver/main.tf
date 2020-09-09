module "webserver_ec2" {
  source = "github.com/aKumoSolutions/terraform-august2020//modules/ec2?ref=v0.0.2"

  env     = "dev"
  session = "session9"
  cidr    = ["0.0.0.0/0"]
  instance_type = "t2.micro"
  region = "us-east-1"
}

module "tagging" {
  source = "../../../modules/tagging"

  env = "dev01-us"
}

output "tags" {
  value = module.tagging.tags
}

data "aws_db_instance" "database" {
  db_instance_identifier = "${var.env}-rds-terraform"
}

output "db_address" {
  value = data.aws_db_instance.database.address
}

variable "env" {
  default = "dev"
}