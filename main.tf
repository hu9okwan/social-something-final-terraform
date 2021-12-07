terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.27"
        }
    }
    required_version = ">= 1.0.0"
}

provider "aws" {
    region = var.region
}


// VPC ------------------------------------------------------------------------
module "my_vpc" {
    source = "./modules/vpc"

    region              = var.region
    bucket_name         = module.my_s3_bucket.bucket_name
    vpc_cidr            = "10.0.0.0/16"

    // lb public subnets
    public_sub_1_cidr   = "10.0.1.0/24"
    public_sub_2_cidr   = "10.0.2.0/24"
    public_sub_3_cidr   = "10.0.3.0/24"

    // ec2 public subnets
    private_sub_1_cidr  = "10.0.4.0/24" // subnet for app on az1
    private_sub_2_cidr  = "10.0.5.0/24" // subnet for app on az2
    private_sub_3_cidr  = "10.0.6.0/24" // subnet for app on az3

    // rds private subnets
    private_sub_4_cidr   = "10.0.7.0/24"
    private_sub_5_cidr   = "10.0.8.0/24"
    private_sub_6_cidr   = "10.0.9.0/24"
}




