#will be referenced from the output of the vpc output.tf
# variable "vpc_id" {
#   description = "The ID of the VPC"
#   type        = string
# }

# variable "alb_security_group" {
#   description = "The security group of the alb"
#   type        = string
# }

# variable "subnets" {
#   type = list(string)
# }

variable "name" {
  description = "Name of the load balancer"
  type        = string
}
variable "internal" {
  description = "Whether the LB is internal"
  type        = bool
}
variable "security_group_id" {
  description = "The Security Group ID for the LB"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnets for the LB"
  type        = list(string)
}
variable "environment" {
  description = "Environment tag for resources"
  type        = string
}