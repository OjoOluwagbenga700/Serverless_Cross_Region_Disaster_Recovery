output "dr_functions_invoke_arns" {
  value = {
    for name, function in aws_lambda_function.dr_functions :
    name => function.invoke_arn
  }
}

output "dr_functions_urls" {
  value = {
    for name, function in aws_lambda_function.dr_functions :
    name => aws_lambda_function_url.urls[name].function_url
  }
}

output "dr_functions_names" {
  value = {
    for name, function in aws_lambda_function.dr_functions :
    name => function.function_name
  }
}