data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_custom_policy" {
  name        = "DR_lambda_custom_policy"
  description = "Policy for Lambda to access aws services"
  policy = jsonencode({
   Version = "2012-10-17",
   Statement = [
    {
      Effect = "Allow",
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:BatchGetItem",
        "dynamodb:Scan" 
      ],
      Resource = [
     "arn:aws:dynamodb:${var.pri_region}:${data.aws_caller_identity.current.account_id}:table/${var.table_name}"
      ]
    },
    
    {
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream", 
        "logs:PutLogEvents"
      ]
      Resource = "arn:aws:logs:${var.pri_region}:${data.aws_caller_identity.current.account_id}:*"
    }
    
   ]
})
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_custom_policy.arn
}