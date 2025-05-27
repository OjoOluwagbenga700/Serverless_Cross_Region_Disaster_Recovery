output "domain_name_target" {
  value = aws_apigatewayv2_domain_name.custom.domain_name_configuration[0].target_domain_name
}

output "domain_name_zone_id" {
  value = aws_apigatewayv2_domain_name.custom.domain_name_configuration[0].hosted_zone_id
}
