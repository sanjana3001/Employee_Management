############################lamda function for Email triggers############################
data "archive_file" "lambda_1" {
  type        = "zip"
  source_file = "lamda/sendAlertEmail/index.js"
  output_path = "sendAlertEmail.zip"
}

resource "aws_lambda_function" "send_alert_email" {
  function_name = "SendAlertEmail"
  role          = aws_iam_role.employeeAlert_lambda_role.arn
  runtime       = "nodejs16.x"
  filename      = "sendAlertEmail.zip"
  handler       = "index.handler"
  timeout       = "15"

  source_code_hash = data.archive_file.lambda.output_base64sha256

}

############################Policies############################
resource "aws_iam_policy" "employeeAlert_lambda_policy" {
  name        = "employeeAlert_lambda_policy"
  path        = "/"
  description = "Policy to be attached to lambda"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "ses:*",
          "logs:*",
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams",
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "employeeAlert_lambda_role" {
  name = "employeeAlert_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "employeeAlert_lambda_role_attach" {
  role       = aws_iam_role.employeeAlert_lambda_role.name
  policy_arn = aws_iam_policy.employeeAlert_lambda_policy.arn
}
