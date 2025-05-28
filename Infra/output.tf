output "route53_domain_name" {
  description = "The domain name of the Route 53 hosted zone"
  value       = module.route53.route53_domain_name
}

output "api_custom_domain_name" {
  description = "The custom domain name for the API Gateway"
  value       = module.apigateway_primary.api_custom_domain_name

}
