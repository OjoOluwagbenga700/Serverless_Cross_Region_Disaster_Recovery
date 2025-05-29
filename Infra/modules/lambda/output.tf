output "dr_functions_invoke_arns" {
  value = {
    for name, function in aws_lambda_function.dr_functions :
    name => function.invoke_arn
  }
}


output "dr_functions_arns" {
  value = {
    for name, function in aws_lambda_function.dr_functions :
    name => function.arn
  }
}