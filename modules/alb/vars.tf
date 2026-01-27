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