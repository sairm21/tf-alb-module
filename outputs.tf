output "lb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "listener_arn" {
  value = var.name == "Public" ? aws_lb_listener.main[0].arn : aws_lb_listener.private[0].arn
}