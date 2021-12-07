
resource "aws_db_instance" "social_something_rds" {
    allocated_storage      = 20
    engine                 = "mysql"
    engine_version         = "8.0"
    instance_class         = "db.t2.micro"
    username               = "${var.rds_user}"
    password               = "${var.rds_password}"
    skip_final_snapshot    = true
    vpc_security_group_ids = [var.db_sg_id]
    db_subnet_group_name   = aws_db_subnet_group.social_something_db_subnet_group.id
    # multi_az               = true // disable for now to load terraform faster
}

resource "aws_db_subnet_group" "social_something_db_subnet_group" {
  name       = "main"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

