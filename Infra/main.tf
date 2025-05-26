module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.table_name
  pri_region = var.pri_region
  sec_region = var.sec_region
}

module "iam" {
  source     = "./modules/iam"
  pri_region = var.pri_region
  table_name = var.table_name
}

module "lambda_primary" {
  source          = "./modules/lambda"
  table_name      = var.table_name
  lambda_role_arn = module.iam.lambda_role_arn
  providers       = { aws = aws.primary }

}

module "lambda_secondary" {
  source          = "./modules/lambda"
  table_name      = var.table_name
  lambda_role_arn = module.iam.lambda_role_arn
  providers       = { aws = aws.secondary }

}

module "apigateway_primary" {
  source                   = "./modules/apigateway"
  providers                = { aws = aws.primary }
  dr_functions_invoke_arns = module.lambda_primary.dr_functions_invoke_arns
}

module "apigateway_secondary" {
  source                   = "./modules/apigateway"
  providers                = { aws = aws.secondary }
  dr_functions_invoke_arns = module.lambda_secondary.dr_functions_invoke_arns
}