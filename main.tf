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
    bucket_name         = var.bucket_name
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


// Auto scaling group ---------------------------------------------------------
module "my_auto_scaling" {
    source = "./modules/asg"

    target_group_arns   = [module.my_lb.target_group_arn]
    private_subnet_ids  = [module.my_vpc.private_subnet_id_1, module.my_vpc.private_subnet_id_2, module.my_vpc.private_subnet_id_3]
    private_sg_id       = module.my_vpc.private_sg_id_1

    bucket_name         = var.bucket_name
    bucket_region       = module.my_s3_bucket.bucket_region
    rds_address         = module.my_rds.rds_address
    sql_user            = var.sql_user
    sql_password        = var.sql_password
    sql_database        = var.sql_database
}



// Load balancer --------------------------------------------------------------

module "my_lb" {
    source = "./modules/lb"

    security_groups     = module.my_vpc.public_sg_id
    subnets             = [module.my_vpc.public_subnet_id_1, module.my_vpc.public_subnet_id_2, module.my_vpc.public_subnet_id_3]
    vpc_id              = module.my_vpc.vpc_id

    certificate_arn     = aws_acm_certificate_validation.final_certificate_validation.certificate_arn
}


// S3 Bucket ------------------------------------------------------------------

module "my_s3_bucket" {
    source              = "./modules/s3bucket"
    bucket_name         = var.bucket_name
}


// RDS ------------------------------------------------------------------------

module "my_rds" {
    source              = "./modules/rds"

    db_sg_id            = module.my_vpc.db_sg_id
    private_subnet_ids  = [module.my_vpc.private_subnet_id_4, module.my_vpc.private_subnet_id_5, module.my_vpc.private_subnet_id_6]
    rds_user            = var.rds_user
    rds_password        = var.rds_password

}

// ec2 instance to initialize database and user
resource "aws_instance" "rds_setup_ec2" {
    instance_type          = "t2.micro"
    ami                    = module.my_auto_scaling.social_something_ami
    vpc_security_group_ids = [module.my_vpc.private_sg_id_1]
    subnet_id              = module.my_vpc.private_subnet_id_1

    user_data = base64encode(templatefile("./setuprds.yml", {
        rds_address :  module.my_rds.rds_address
        sql_user :     var.sql_user
        sql_password : var.sql_password
        sql_database : var.sql_database
        rds_user :     var.rds_user
        rds_password : var.rds_password
    }))

    tags = {
        Name = "rds setup"
    }

    depends_on = [
        module.my_rds
    ]
}


// Route 53 -------------------------------------------------------------------

data "aws_route53_zone" "primary" {
    name = "testu.xyz"
}

resource "aws_route53_record" "final" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "final.testu.xyz"
    type    = "A"

    alias {
        name                   = module.my_lb.dns_name
        zone_id                = module.my_lb.zone_id
        evaluate_target_health = true
    }
}

// certificate for sub domain to enable https
resource "aws_acm_certificate" "final_certificate" {
    domain_name       = "final.testu.xyz"
    validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "final_certificate_validation" {
  certificate_arn     = aws_acm_certificate.final_certificate.arn
}
