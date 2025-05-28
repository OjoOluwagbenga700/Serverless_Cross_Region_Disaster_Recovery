# Create Hosted Zone In Route 53
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "custom_domain_primary" {
  zone_id = aws_route53_zone.hosted_zone.id
  name    = var.endpoint
  type    = "A"

  alias {
    name                   = var.apigw_primary_domain_name_target
    zone_id                = var.apigw_primary_domain_name_zone_id
    evaluate_target_health = false
  }

  set_identifier = "primary"
  failover_routing_policy {
    type = "PRIMARY"
  }
  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "custom_domain_secondary" {
  zone_id = aws_route53_zone.hosted_zone.id
  name    = var.endpoint
  type    = "A"

  alias {
    name                   = var.apigw_secondary_domain_name_target
    zone_id                = var.apigw_secondary_domain_name_zone_id
    evaluate_target_health = false
  }

  set_identifier = "secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
  health_check_id = aws_route53_health_check.secondary.id
}


# Health Checks (example, if you use a module or resource for these)
resource "aws_route53_health_check" "primary" {
  fqdn          = var.endpoint
  port          = 443
  type          = "HTTPS"
  resource_path = "/read"
  failure_threshold = 3
  request_interval  = 30
  tags = { Name = "Primary" }
}

resource "aws_route53_health_check" "secondary" {
  fqdn          = var.endpoint
  port          = 443
  type          = "HTTPS"
  resource_path = "/read"
  failure_threshold = 3
  request_interval  = 30
  tags = { Name = "Secondary" }
}