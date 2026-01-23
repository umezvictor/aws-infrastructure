output "vpc_id" {
  value = aws_vpc.main.id
}

output "cidr" {
  value = aws_vpc.main.cidr_block
}