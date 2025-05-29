locals {
  api_routes = {
    "GET /read"                  = "read_function"
    "POST /write"                 = "write_function"
  }
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "http-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins     = ["*"]
    allow_methods     = ["GET", "POST", "OPTIONS"]
    allow_headers     = ["*"]
    expose_headers    = []
    max_age           = 3600
    allow_credentials = false
  }
}

resource "aws_apigatewayv2_integration" "api_lambda_integrations" {
  for_each = local.api_routes

  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.dr_functions_invoke_arns[each.value]
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "routes" {
  for_each = local.api_routes

  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.api_lambda_integrations[each.key].id}"
}


resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "prod"
  auto_deploy = true 
}

resource "aws_apigatewayv2_domain_name" "custom" {
  domain_name = var.endpoint
  depends_on = [var.certificate_validation_arn]

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "custom" {
  api_id      = aws_apigatewayv2_api.http_api.id
  domain_name = aws_apigatewayv2_domain_name.custom.domain_name
  stage       = aws_apigatewayv2_stage.api_stage.name
}

resource "aws_lambda_permission" "api_gateway_permissions" {
  for_each = local.api_routes

  statement_id  = "AllowAPIGatewayInvoke-${each.value}"
  action        = "lambda:InvokeFunction"
  function_name = var.dr_functions_arns[each.value]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}