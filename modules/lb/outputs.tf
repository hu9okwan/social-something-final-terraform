output "dns_name" {
    value = aws_lb.http_lb.dns_name
}


output "target_group_arn" {
    value = aws_lb_target_group.app_tg.arn
}

output "zone_id" {
    # "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
    value = aws_lb.http_lb.zone_id
}