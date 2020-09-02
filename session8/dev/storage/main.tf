module "storage_rds" {
  source = "../../../modules/rds"

  env     = var.r_env
  storage = var.r_storage
  cidr    = var.r_cidr
}

resource "aws_security_group_rule" "rds_add_rule" {
  type = "ingress"
  security_group_id = module.storage_rds.rds_sg_id

  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}

output "db_address" {
  value = module.storage_rds.m_db_address
}