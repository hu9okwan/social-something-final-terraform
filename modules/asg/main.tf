data "aws_ami" "social_something_ami" {
  most_recent = true
  name_regex  = "social-something-*"
  owners      = ["self"]
}

resource "aws_launch_template" "app_template" {
    name_prefix   = "app_template"
    image_id      = data.aws_ami.social_something_ami.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [var.private_sg_id]
    user_data     = base64encode(templatefile("${path.module}/app.yml", {
      bucket_region : var.bucket_region
      bucket_name :   var.bucket_name
      sql_host :      var.rds_address 
      sql_user :      var.sql_user
      sql_password :  var.sql_password
      sql_database :  var.sql_database
    }))
    iam_instance_profile {
      name = "${aws_iam_instance_profile.instance_profile.name}"
    }
}

resource "aws_autoscaling_group" "app_auto_scaling_group" {
    vpc_zone_identifier = var.private_subnet_ids
    desired_capacity    = 2
    max_size            = 3
    min_size            = 2

    target_group_arns = var.target_group_arns

    launch_template {
        id      = aws_launch_template.app_template.id
        version = "$Latest"
    }
}


// IAM Policy -----------------------------------------------------------------

// Policy that allows put get del on s3 bucket
resource "aws_iam_policy" "bucket_policy" {
  name        = "put_get_del_policy"
  path        = "/"
  description = "Policy that allows Put/get/delete object"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::${var.bucket_name}"
        ]
      }
    ]
  })
}


// IAM Role for put,get,del on bucket
resource "aws_iam_role" "bucket_role" {
  name = "bucket_role"

  # This is a role for EC2 instances
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

// IAM Role Attachment policy to role
resource "aws_iam_role_policy_attachment" "bucket_policy_attachment" {
  role       = aws_iam_role.bucket_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}

// IAM role attachment for cloudwatch
resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  role       = aws_iam_role.bucket_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

// IAM instance profile attaches to ec2 instance as middleman
resource "aws_iam_instance_profile" "instance_profile" {
  name = "bucket_role_profile"
  role = aws_iam_role.bucket_role.name
}