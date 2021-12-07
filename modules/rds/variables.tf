variable "db_sg_id" {
    description = "ID of the security group for the db security group"
    type        = string
}


variable "private_subnet_ids" {
    description = "IDs of the private subnets"
    type        = list
}



variable "rds_user" {
    description = "root/admin user of rds"
    type        = string
}

variable "rds_password" {
    description = "Password for rds root user"
    type        = string
}
