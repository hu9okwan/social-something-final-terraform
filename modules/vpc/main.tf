resource "aws_vpc" "some_custom_vpc" {
    cidr_block = var.vpc_cidr

    enable_dns_hostnames = true
    tags = {
        Name = "Some Custom VPC"
    }
}

// endpoint for s3
resource "aws_vpc_endpoint" "s3" {
    vpc_id       = aws_vpc.some_custom_vpc.id
    service_name = "com.amazonaws.${var.region}.s3"
    vpc_endpoint_type = "Gateway"
    route_table_ids = [aws_vpc.some_custom_vpc.main_route_table_id]

    policy = <<POLICY
    {
        "Statement" : [
            {
                "Sid" : "VisualEditor0",
                "Effect" : "Allow",
                "Principal": "*",
                "Action" : [
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:ListObject",
                    "s3:DeleteObject"
                ],
                "Resource" : [
                    "arn:aws:s3:::${var.bucket_name}",
                    "arn:aws:s3:::${var.bucket_name}/*"
                ]
            }
        ],
        "Version" : "2012-10-17"
    }
    POLICY
}

// https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/cloudwatch-logs-and-interface-VPC.html
resource "aws_vpc_endpoint" "logs" {
    vpc_id            = aws_vpc.some_custom_vpc.id
    service_name      = "com.amazonaws.${var.region}.logs"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true

    security_group_ids = [
        aws_security_group.public_sg.id
    ]

    subnet_ids = [
        aws_subnet.some_private_subnet_1.id, 
        aws_subnet.some_private_subnet_2.id, 
        aws_subnet.some_private_subnet_3.id
    ]

    policy = <<POLICY
    {
        "Statement": [
            {
                "Sid": "PutOnly",
                "Principal": "*",
                "Action": [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Effect": "Allow",
                "Resource": "*"
            }
        ]
    }
    POLICY
}

resource "aws_vpc_endpoint" "monitoring" {
    vpc_id            = aws_vpc.some_custom_vpc.id
    service_name      = "com.amazonaws.${var.region}.monitoring"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true

    security_group_ids = [
        aws_security_group.public_sg.id
    ]

    subnet_ids = [
        aws_subnet.some_private_subnet_1.id, 
        aws_subnet.some_private_subnet_2.id, 
        aws_subnet.some_private_subnet_3.id
    ]

    policy = <<POLICY
    {
        "Statement": [
            {
                "Sid": "PutOnly",
                "Principal": "*",
                "Action": [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Effect": "Allow",
                "Resource": "*"
            }
        ]
    }
    POLICY
}



// public subnets -------------------------------------------------------------

resource "aws_subnet" "some_public_subnet_1" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.public_sub_1_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "Some Public Subnet 1"
  }
}

resource "aws_subnet" "some_public_subnet_2" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.public_sub_2_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "Some Public Subnet 2"
  }
}

resource "aws_subnet" "some_public_subnet_3" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.public_sub_3_cidr
  availability_zone = "${var.region}c"

  tags = {
    Name = "Some Public Subnet 3"
  }
}

// private subnets ------------------------------------------------------------

resource "aws_subnet" "some_private_subnet_1" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.private_sub_1_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "Some Private Subnet 1"
  }
}

resource "aws_subnet" "some_private_subnet_2" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.private_sub_2_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "Some Private Subnet 2"
  }
}

resource "aws_subnet" "some_private_subnet_3" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.private_sub_3_cidr
  availability_zone = "${var.region}c"

  tags = {
    Name = "Some Private Subnet 3"
  }
}

resource "aws_subnet" "some_private_subnet_4" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.private_sub_4_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "Some Private Subnet 4"
  }
}

resource "aws_subnet" "some_private_subnet_5" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.private_sub_5_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "Some Private Subnet 5"
  }
}

resource "aws_subnet" "some_private_subnet_6" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.private_sub_6_cidr
  availability_zone = "${var.region}c"

  tags = {
    Name = "Some Private Subnet 6"
  }
}

resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id

  tags = {
    Name = "Some Internet Gateway"
  }
}


// Routing tables -------------------------------------------------------------


// public routing table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.some_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.some_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.some_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

// public table associations with public subnets
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_3_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet_3.id
  route_table_id = aws_route_table.public_rt.id
}



# // private routing table is created by default so dont need to make 1

# // private table associations with private subnets (seems liek these are auto associated)
# resource "aws_route_table_association" "private_1_rt_a" {
#   subnet_id      = aws_subnet.some_private_subnet_1.id
#   route_table_id = aws_vpc.some_custom_vpc.main_route_table_id
# }

# resource "aws_route_table_association" "private_2_rt_a" {
#   subnet_id      = aws_subnet.some_private_subnet_2.id
#   route_table_id = aws_vpc.some_custom_vpc.main_route_table_id
# }

# resource "aws_route_table_association" "private_3_rt_a" {
#   subnet_id      = aws_subnet.some_private_subnet_3.id
#   route_table_id = aws_vpc.some_custom_vpc.main_route_table_id
# }


// Security Groups ------------------------------------------------------------

resource "aws_security_group" "public_sg" {
    name   = "HTTP and HTTPS"
    vpc_id = aws_vpc.some_custom_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "private_sg" {
    name   = "Private HTTP"
    vpc_id = aws_vpc.some_custom_vpc.id

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = [var.vpc_cidr]
    }

    // need to enable port 443 so cloudwatch can reach instances
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        # cidr_blocks = [var.vpc_cidr] // not sure if can be restricted?
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

// rds instance SG
resource "aws_security_group" "db_sg" {
    name        = "db_sg"
    description = "Allow on port 3306 in private VPC" 
    vpc_id = aws_vpc.some_custom_vpc.id
    
    ingress {
        from_port        = 3306
        to_port          = 3306
        protocol         = "tcp"
        cidr_blocks      = [var.vpc_cidr] 
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}