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
  region     = "eu-north-1"
  access_key = "AKIATZWXOULJKBJXNOGJ"
  secret_key = "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"
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
  name              = "image-resizer-load-balancer"
  internal          = false
  security_group_id = module.internal_alb_security_group.alb_security_group
  subnet_ids = [
    module.vpc.public_subnet_id,
    module.vpc.private_subnet_id
  ]
  environment = "production"
}



#ssl certificate - ssl
# resource "aws_acm_certificate" "cert" {
#   domain_name       = "eventsenta.com"
#   validation_method = "DNS"

#   tags = {
#     Environment = "production"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_zone" "eventsenta" {
#   name = "eventsenta.com"
# }


# resource "aws_route53_record" "api" {
#   zone_id = aws_route53_zone.eventsenta.zone_id
#   name    = "api"
#   type    = "A"

#   alias {
#     name                   = "production.eba-drp5a2ki.eu-north-1.elasticbeanstalk.com"
#     zone_id                = "Z23GO28BZ5AETM" #zone id of elasticbeanstalk see https://docs.aws.amazon.com/general/latest/gr/elasticbeanstalk.html
#     evaluate_target_health = true
#   }
# }



# resource "aws_route53_record" "api" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   zone_id = aws_route53_zone.eventsenta.zone_id
#   name    = "api"
#   type    = "A"

#   alias {
#     name                   = "production.eba-drp5a2ki.eu-north-1.elasticbeanstalk.com"
#     zone_id                = "Z23GO28BZ5AETM" #zone id of elasticbeanstalk see https://docs.aws.amazon.com/general/latest/gr/elasticbeanstalk.html
#     evaluate_target_health = true
#   }

#   allow_overwrite = true
#   records         = [each.value.record]
# }

# resource "aws_acm_certificate_validation" "cert-validation" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.api : record.fqdn]
# }

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.front_end.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.front_end.arn
#   }
# }