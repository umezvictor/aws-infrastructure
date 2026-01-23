terraform {
  cloud {
    organization = "victorblaze22"

    workspaces {
      tags = ["aws-infrastructure"]
    }
    # workspaces {
    #   project = "aws-infrastructure"
    #   name    = "learn-terraform"
    # }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = "eu-north-1"
}

module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  env         = var.env
}

module "vpc" {
  source = "./modules/vpc"
  cidr   = var.cidr
}

module "internal_alb_security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
  cidr   = module.vpc.cidr
}

module "alb" {
  source            = "./modules/alb"
  name              = "internal-alb"
  internal          = true
  security_group_id = module.internal_alb_security_group.security_group_id
  subnet_ids = [
    module.vpc.public_subnet_id,
    module.vpc.private_subnet_id
  ]
  environment = "dev"
}



# resource "aws_lb" "app" {
#   name               = "image-resizer-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [module.internal_alb_security_group.alb_security_group]     # Refer to your SG module output
#   subnets            = [module.vpc.public_subnet_id, module.vpc.private_subnet_id] # Reference public subnet output

#   tags = {
#     Environment = "dev"
#     Name        = "my-app-alb"
#   }
# }