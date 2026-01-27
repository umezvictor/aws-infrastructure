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

resource "aws_route53_zone" "eventsenta" {
  name = "eventsenta.com"
}

#ssl certificate - ssl
resource "aws_acm_certificate" "cert" {
  domain_name       = "eventsenta.com"
  validation_method = "DNS"

  tags = {
    Environment = "production"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.eventsenta.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}
# Wait for validation
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Alias A record for EB
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.eventsenta.zone_id
  name    = "api"
  type    = "A"

  alias {
    name                   = "production.eba-m7mr88qr.eu-north-1.elasticbeanstalk.com"
    zone_id                = "Z23GO28BZ5AETM" #zone id of elasticbeanstalk see https://docs.aws.amazon.com/general/latest/gr/elasticbeanstalk.html
    evaluate_target_health = true
  }
}
