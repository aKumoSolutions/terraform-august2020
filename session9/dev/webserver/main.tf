module "webserver_ec2" {
  source = "../../../modules/ec2"

  env     = "dev"
  session = "session8"
  cidr    = ["0.0.0.0/0"]
  instance_type = "t2.micro"
  region = "us-east-1"
}