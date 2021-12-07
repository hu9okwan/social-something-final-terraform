variable "private_sg_id" {
    description = "ID of the security group for private security group"
    type        = string
}

variable "private_subnet_ids" {
    description = "list of ID for private subnets"
    type        = list
}


variable "target_group_arns" {
    description = "Target group arns"
    type        = list
}


// variables for cloud init

variable "bucket_region" {
  description = "The region of the bucket"
  type        = string
}

variable "bucket_name" {
  description = "The s3 bucket name"
  type        = string
}

variable "rds_address" {
  description = "The adress of rds"
  type        = string
}

variable "sql_user" {
  description = "The user name of the MySQL user"
  type        = string
}

variable "sql_password" {
  description = "The password of the MySQL user"
  type        = string
}

variable "sql_database" {
  description = "The database name to connect to in MySQL"
  type        = string
}


