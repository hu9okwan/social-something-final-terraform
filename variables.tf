# Put variables in here
# This is data coming from the user

variable "region" {
    description = "AWS region"
    type        = string
    default     = "us-west-2"
}

variable "rds_user" {
    description = "root/admin user of rds"
    type        = string
    default     = "root"
}

variable "rds_password" {
    description = "Password for rds root user"
    type        = string
    default     = "MyNewPass1!"
}

variable "sql_user" {
    description = "SQL user of app"
    type        = string
    default     = "web_app"
}

variable "sql_password" {
    description = "Password for SQL user"
    type        = string
    default     = "MyNewPass1"
}

variable "sql_database" {
    description = "Database name that app is using"
    type        = string
    default     = "social_something"
}
