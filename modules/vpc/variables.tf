# Put variables in here
# This is data coming from the root module
# So any arguments that are currently commented out

variable "vpc_cidr" {
    description = "CIDR block for the entire VPC"
    type        = string
}


variable "public_sub_1_cidr" {
    description = "CIDR block for the public subnet 1"
    type        = string
}

variable "public_sub_2_cidr" {
    description = "CIDR block for the public subnet 2"
    type        = string
}

variable "public_sub_3_cidr" {
    description = "CIDR block for the public subnet 3"
    type        = string
}


variable "private_sub_1_cidr" {
    description = "CIDR block for the private subnet 1"
    type        = string
}

variable "private_sub_2_cidr" {
    description = "CIDR block for the private subnet 2"
    type        = string
}

variable "private_sub_3_cidr" {
    description = "CIDR block for the private subnet 3"
    type        = string
}

variable "private_sub_4_cidr" {
    description = "CIDR block for the private subnet 4"
    type        = string
}

variable "private_sub_5_cidr" {
    description = "CIDR block for the private subnet 5"
    type        = string
}

variable "private_sub_6_cidr" {
    description = "CIDR block for the private subnet 6"
    type        = string
}


variable "region" {
    description = "big dogger region"
    type        = string
}

variable "bucket_name" {
    description = "The s3 bucket name"
    type        = string
}