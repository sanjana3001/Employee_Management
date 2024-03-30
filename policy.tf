############################Policy for Employee lamda############################
resource "aws_iam_policy" "employee_lambda_policy" {
  name        = "employee_lambda_policy"
  path        = "/"
  description = "Policy to be attached to Employee lambda"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "logs:*",
          "dynamodb:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

############################Employee Role############################
resource "aws_iam_role" "employee_lambda_role" {
  name = "employee_lambda_role"

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

resource "aws_iam_role_policy_attachment" "employee_lambda_role_attach" {
  role       = aws_iam_role.employee_lambda_role.name
  policy_arn = aws_iam_policy.employee_lambda_policy.arn
}
