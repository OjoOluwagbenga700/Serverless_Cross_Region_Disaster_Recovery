
locals {
  lambda_functions = {
    read_function          = "read_function.py"
    write_function         = "write_function.py"

  }
}


data "archive_file" "lambda_packages" {
  for_each = local.lambda_functions

  type        = "zip"
  source_file = "src/${each.value}"
  output_path = "${replace(each.value, ".py", ".zip")}"
}



resource "aws_lambda_function" "dr_functions" {
  for_each = local.lambda_functions

  function_name = each.key
  handler       = "${replace(each.value, ".py", "")}.lambda_handler"
  runtime       = "python3.9"
  role          = var.lambda_role_arn
  filename      = data.archive_file.lambda_packages[each.key].output_path
  source_code_hash = data.archive_file.lambda_packages[each.key].output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE = var.table_name
      
    }
}

}

