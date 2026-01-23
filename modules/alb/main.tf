# resource "aws_lb" "app" {
#   name               = "image-resizer-alb"
#   internal           = false
#   load_balancer_type = "application"

#   tags = {
#     Environment = "dev"
#     Name        = "my-app-alb"
#   }
# }

resource "aws_lb" "internal" {
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