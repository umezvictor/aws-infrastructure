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

module "internal_alb_security_group" {
  source = "./modules/security-group"
}