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


# resource "aws_route53_record" "hello_cert_dns" {
#   allow_overwrite = true
#   name =  tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
#   records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
#   type = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
#   zone_id = aws_route53_zone.eventsenta.zone_id
#   ttl = 60
# }

# resource "aws_acm_certificate_validation" "api_cert_validation" {
#   certificate_arn = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [aws_route53_record.hello_cert_dns.fqdn]
# }

resource "aws_route53_zone" "eventsenta" {
  name = "eventsenta.com"
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = "eventsenta.com"
  subject_alternative_names = ["www.eventsenta.com", "*.eventsenta.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm-records" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records = [
    each.value.record
  ]
  ttl     = 60
  type    = each.value.type
  zone_id = aws_route53_zone.eventsenta.zone_id
}

resource "aws_acm_certificate_validation" "acm-validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm-records : record.fqdn]
}
