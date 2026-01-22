terraform {
  cloud {
    organization = "victorblaze22"

    workspaces {
      project = "aws-infrastructure"
      name    = "learn-terraform"
    }
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
  region     = "eu-north-1"
  access_key = ""
  secret_key = ""
}

module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  env         = var.env
}
