resource "aws_lb" "app_lb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}