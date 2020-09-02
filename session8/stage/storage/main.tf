module "storage_rds" {
  source = "../../../modules/rds"

  env     = var.r_env
  storage = var.r_storage
  cidr    = var.r_cidr
}