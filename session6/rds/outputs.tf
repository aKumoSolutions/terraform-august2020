output "db_address" {
    value = aws_db_instance.rds_users.address
}

output "db_info" {
    value = {
        "username": aws_db_instance.rds_users.username
        "arn": aws_db_instance.rds_users.arn
    }
}