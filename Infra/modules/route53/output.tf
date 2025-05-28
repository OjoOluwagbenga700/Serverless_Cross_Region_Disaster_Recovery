output "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone"
  value       = aws_route53_zone.hosted_zone.zone_id
  
}

output "route53_domain_name" {
  description = "The domain name of the Route 53 hosted zone"
  value       = aws_route53_zone.hosted_zone.name
}