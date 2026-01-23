output "vpc_id" {
  value = aws_vpc.main.id
}

output "cidr" {
  value = aws_vpc.main.cidr_block
}

# output "public_subnets" {
#   value = [for subnet in aws_subnet.public_subnet : subnet.id]
# }

output "public_subnet_id" {
  value = aws_subnet.public.id
}