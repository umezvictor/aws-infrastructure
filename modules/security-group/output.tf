#value = <resource_type>.<resource_name>.<attribute>
output "alb_security_group" {
  value = aws_security_group.allow_tls.id
}