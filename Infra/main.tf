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

module "lambda" {
  source          = "./modules/lambda"
  table_name      = var.table_name
  lambda_role_arn = module.iam.lambda_role_arn
}