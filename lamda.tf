############################Lamda function for Employee Data############################
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lamda/employeeData/index.js"
  output_path = "employeeData.zip"
}

resource "aws_lambda_function" "employee_lamda" {
  function_name = "employee_lamda"
  role          = aws_iam_role.employee_lambda_role.arn
  runtime       = "nodejs16.x"
  filename      = "employeeData.zip"
  handler       = "index.handler"
  timeout       = "15"

  source_code_hash = data.archive_file.lambda.output_base64sha256
}
