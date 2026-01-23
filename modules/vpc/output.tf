output "vpc_id" {
  value = aws_vpc.main.id
}

output "cidr" {
  value = aws_vpc.main.cidr_block
}

# output "public_subnets" {
#   value = [for subnet in aws_subnet.public_subnet : subnet.id]
# }

#This makes it available to reference from your root module
output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}