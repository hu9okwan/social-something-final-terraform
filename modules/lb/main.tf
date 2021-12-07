# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

# Create An Application Load Balancer
resource "aws_lb" "http_lb" {
    name               = "http-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.security_groups]
    subnets            = var.subnets

    enable_deletion_protection = false
}

# Listen for requests on port 443 and forward those requests to the target group
resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.http_lb.arn
    port              = "443"
    protocol          = "HTTPS"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.app_tg.arn
    }

    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = var.certificate_arn
}

# listen on port 80 and redirects to 443
resource "aws_lb_listener" "front_end_redirect_http" {
    load_balancer_arn = aws_lb.http_lb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "redirect"
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}


# Create a target group that will send traffic over port 8080
resource "aws_lb_target_group" "app_tg" {
    name     = "app-tg"
    port     = 8080
    protocol = "HTTP"
    vpc_id   = var.vpc_id
}

# Direct the traffic to the ec2 instance
# resource "aws_lb_target_group_attachment" "app_attachment" {
#   port             = 8080
#   target_group_arn = aws_lb_target_group.app_tg.arn
#   # The id of the ec2 instance:
#   target_id        = var.ec2_id
# }

