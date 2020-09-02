output "rds_sg_id" {
    value = aws_security_group.rds_sg.id
}

output "m_db_address" {
    value = aws_db_instance.rds_users.address
}