# Create Hosted Zone In Route 53
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "primary_api" {
  zone_id = aws_route53_zone.hosted_zone.id
  name    = "primary-api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.apigw_primary_domain_name_target
    zone_id                = var.apigw_primary_domain_name_zone_id
    evaluate_target_health = true
  }

  set_identifier = "primary"
  failover_routing_policy {
    type = "PRIMARY"
  }
  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "secondary_api" {
  zone_id = aws_route53_zone.hosted_zone.id
  name    = "secondary-api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.apigw_secondary_domain_name_target
    zone_id                = var.apigw_secondary_domain_name_zone_id
    evaluate_target_health = true
  }

  set_identifier = "secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
  health_check_id = aws_route53_health_check.secondary.id
}


# Health Checks (example, if you use a module or resource for these)
resource "aws_route53_health_check" "primary" {
  fqdn          = "primary-api.${var.domain_name}"
  port          = 443
  type          = "HTTPS"
  resource_path = "/read"
  failure_threshold = 3
  request_interval  = 30
  tags = { Name = "Primary" }
}

resource "aws_route53_health_check" "secondary" {
  fqdn          = "secondary-api.${var.domain_name}"
  port          = 443
  type          = "HTTPS"
  resource_path = "/read"
  failure_threshold = 3
  request_interval  = 30
  tags = { Name = "Secondary" }
}


# Main failover record for clients
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.hosted_zone.id
  name    = "api.${var.domain_name}"
  type    = "A"

  set_identifier = "api-failover"
  failover_routing_policy {
    type = "PRIMARY"
  }
  alias {
    name                   = aws_route53_record.primary_api.fqdn
    zone_id                = aws_route53_zone.hosted_zone.id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_secondary" {
  zone_id = aws_route53_zone.hosted_zone.id
  name    = "api.${var.domain_name}"
  type    = "A"

  set_identifier = "api-failover-secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
  alias {
    name                   = aws_route53_record.secondary_api.fqdn
    zone_id                = aws_route53_zone.hosted_zone.id
    evaluate_target_health = true
  }
}