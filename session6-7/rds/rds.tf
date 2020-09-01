resource "aws_db_instance" "rds_users" {
  allocated_storage         = 5
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t2.micro"
  name                      = replace(var.schema_name, "-", "_")
  username                  = "master"
  password                  = random_password.db_password.result
  parameter_group_name      = "default.mysql5.7"
  apply_immediately         = true
  final_snapshot_identifier = var.skip_snapshot == true ? null : format("%s-rds-users-snapshot", var.env)
  identifier                = "${var.env}-rds-terraform"
  skip_final_snapshot       = var.skip_snapshot
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  publicly_accessible       = var.env == "dev" ? true : false
}

resource "null_resource" "create_table" {
  triggers = {
    # sql = file("table.sql")
    every_time = timestamp()
  }
  depends_on = [aws_db_instance.rds_users]
  provisioner "local-exec" {
    command = <<-EOF
                mysql -h "${aws_db_instance.rds_users.address}" -u "${aws_db_instance.rds_users.username}" < "table.sql"
            EOF
    environment = {
      MYSQL_PWD = random_password.db_password.result
    }
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.env}-rds-sg"
  description = "sg for rds db instance"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
}

resource "random_password" "db_password" {
  keepers = {
    sql = file("table.sql")
  }
  length           = 16
  special          = true
  override_special = "_%#!$"
}
