terraform {
  cloud {

    organization = "victorblaze22"

    workspaces {
      name = "elasticbeanstalk-demo-infrastructure"
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
  region = "eu-north-1"
}

# module "s3_bucket" {
#   source      = "./modules/s3"
#   bucket_name = var.bucket_name
#   env         = var.env
# }

# module "vpc" {
#   source = "./modules/vpc"
#   cidr   = var.cidr
# }

# module "internal_alb_security_group" {
#   source = "./modules/security-group"
#   vpc_id = module.vpc.vpc_id
#   cidr   = module.vpc.cidr
# }

# module "alb" {
#   source            = "./modules/alb"
#   name              = "image-resizer-alb2"
#   internal          = false
#   security_group_id = module.internal_alb_security_group.alb_security_group
#   subnet_ids = [
#     module.vpc.public_subnet_id,
#     module.vpc.private_subnet_id
#   ]
#   environment = "dev"
# }

# resource "aws_s3_bucket" "deployment" {
#   bucket = "victorblaze-deployment-bucket"
# }

# #upload file to s3 bucket - move zip folder to same directory as terraform
# resource "aws_s3_object" "deployment-file" {
#   bucket = "victorblaze-deployment-bucket"
#   key    = "ebsdemoapi.zip"
#   source = "ebsdemoapi.zip"
#   etag   = filemd5("ebsdemoapi.zip")
# }

# #elb
# resource "aws_elastic_beanstalk_application" "imageresizer-ebs" {
#   name        = "imageresizerapi"
#   description = "image-resizer-elastic beanstalk"

#   appversion_lifecycle {
#     service_role          = "arn:aws:iam::261371110098:role/aws-elasticbeanstalk-imageresizerapi-role" #aws-elasticbeanstalk-imageresizerapi-role aws_iam_role.beanstalk_service.arn
#     max_count             = 128
#     delete_source_from_s3 = true
#   }
# }

# resource "aws_elastic_beanstalk_application_version" "imageresizerapi-version" {
#   name        = "image-resizer-api-v1"
#   application = "imageresizerapi"
#   description = "application version created by terraform"
#   bucket      = aws_s3_bucket.deployment.id
#   key         = aws_s3_object.deployment-file.key
# }

# resource "aws_elastic_beanstalk_environment" "imageresizer-ebs-env" {
#   name         = "production"
#   application  = aws_elastic_beanstalk_application.imageresizer-ebs.name
#   tier         = "WebServer"
#   platform_arn = "arn:aws:elasticbeanstalk:eu-north-1::platform/.NET 8 running on 64bit Amazon Linux 2023/3.7.1"

#   version_label = aws_elastic_beanstalk_application_version.imageresizerapi-version.name

#   # i already created the ec2 instance and service role manually in aws console. do this within terraform
#   # Attach EC2 instance profile (required!)
#   setting {
#     namespace = "aws:autoscaling:launchconfiguration"
#     name      = "IamInstanceProfile"
#     value     = "aws-elasticbeanstalk-ec2-role" # or whatever your instance profile is named!
#   }

#   # Attach service role (optional but recommended especially for enhanced health etc)
#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "ServiceRole"
#     value     = "arn:aws:iam::261371110098:role/aws-elasticbeanstalk-imageresizerapi-role" # use role ARN
#   }
# }

resource "aws_route53_zone" "eventsenta" {
  name = "eventsenta.com"
}


resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.eventsenta.zone_id
  name    = "api"
  type    = "A"

  alias {
    name                   = "production.eba-drp5a2ki.eu-north-1.elasticbeanstalk.com"
    zone_id                = "Z23GO28BZ5AETM" #zone id of elasticbeanstalk see https://docs.aws.amazon.com/general/latest/gr/elasticbeanstalk.html
    evaluate_target_health = true
  }
}