output "lb_arn" {
  value = aws_lb.app_lb.arn
}
output "lb_dns_name" {
  value = aws_lb.app_lb.dns_name
}