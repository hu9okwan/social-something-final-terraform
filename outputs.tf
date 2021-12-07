# Put any outputs in here
# Data that you want to see printed to the terminal
# Probably the dns name for the load balancer

# output "dns_name" {
#     value = module.my_lb.dns_name
# }

output "domain_name" {
    value = aws_route53_record.final.name
}