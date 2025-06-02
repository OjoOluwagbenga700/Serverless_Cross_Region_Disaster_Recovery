# DynamoDB table must be created first as it's referenced by Lambda functions
module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.table_name
  pri_region = var.pri_region
  sec_region = var.sec_region
}

# IAM roles and policies needed by Lambda functions
module "iam" {
  source     = "./modules/iam"
  pri_region = var.pri_region
  table_name = var.table_name
  sec_region = var.sec_region

}

# Primary region Lambda functions depend on DynamoDB and IAM
module "lambda_primary" {
  source          = "./modules/lambda"
  table_name      = var.table_name
  lambda_role_arn = module.iam.lambda_role_arn
  providers       = { aws = aws.primary }


}

# Secondary region Lambda functions depend on DynamoDB and IAM
module "lambda_secondary" {
  source          = "./modules/lambda"
  table_name      = var.table_name
  lambda_role_arn = module.iam.lambda_role_arn
  providers       = { aws = aws.secondary }


}

# Primary API Gateway depends on Lambda functions and ACM certificate
module "apigateway_primary" {
  source                     = "./modules/apigateway"
  providers                  = { aws = aws.primary }
  dr_functions_invoke_arns   = module.lambda_primary.dr_functions_invoke_arns
  dr_functions_arns          = module.lambda_primary.dr_functions_arns
  certificate_validation_arn = module.acm_primary.certificate_validation_arn
  domain_name                = var.domain_name
  certificate_arn            = module.acm_primary.certificate_arn

}

# Secondary API Gateway depends on Lambda functions and ACM certificate
module "apigateway_secondary" {
  source                     = "./modules/apigateway"
  providers                  = { aws = aws.secondary }
  dr_functions_invoke_arns   = module.lambda_secondary.dr_functions_invoke_arns
  dr_functions_arns          = module.lambda_secondary.dr_functions_arns
  certificate_validation_arn = module.acm_secondary.certificate_validation_arn
  domain_name                = var.domain_name
  certificate_arn            = module.acm_secondary.certificate_arn

}

# Primary region ACM certificate depends on Route53 hosted zone
module "acm_primary" {
  source         = "./modules/acm"
  domain_name    = var.domain_name
  providers      = { aws = aws.primary }
  hosted_zone_id = module.route53.hosted_zone_id

}

# Secondary region ACM certificate depends on Route53 hosted zone
module "acm_secondary" {
  source         = "./modules/acm"
  domain_name    = var.domain_name
  providers      = { aws = aws.secondary }
  hosted_zone_id = module.route53.hosted_zone_id

}

# Route53 DNS records depend on API Gateway domain names
module "route53" {
  source                              = "./modules/route53"
  domain_name                         = var.domain_name
  providers                           = { aws = aws.primary }
  apigw_primary_domain_name_target    = module.apigateway_primary.domain_name_target
  apigw_primary_domain_name_zone_id   = module.apigateway_primary.domain_name_zone_id
  apigw_secondary_domain_name_target  = module.apigateway_secondary.domain_name_target
  apigw_secondary_domain_name_zone_id = module.apigateway_secondary.domain_name_zone_id
}
