module "storage_rds" {
  source = "github.com/aKumoSolutions/terraform-august2020//modules/rds?ref=v0.0.1"

  env     = var.r_env
  storage = var.r_storage
  cidr    = var.r_cidr
}