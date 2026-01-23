#will be referenced from the output of the vpc output.tf
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "alb_security_group" {
  description = "The security group of the alb"
  type        = string
}