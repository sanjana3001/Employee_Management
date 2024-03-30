
############################ API Gateway for employee ############################P
resource "aws_api_gateway_rest_api" "employee_api_gw" {
  name        = "employee_api_gw"
  description = "REST API to CRUD Employee Data"
}

resource "aws_api_gateway_resource" "employee_resource" {
  rest_api_id = aws_api_gateway_rest_api.employee_api_gw.id
  parent_id   = aws_api_gateway_rest_api.employee_api_gw.root_resource_id
  path_part   = "employeeData"
}

############################ POST HTTP Method ##################################

resource "aws_api_gateway_method" "post_employee_data" {
  rest_api_id   = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id   = aws_api_gateway_resource.employee_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "post_employee_data_response_200" {
  rest_api_id = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id = aws_api_gateway_resource.employee_resource.id
  http_method = aws_api_gateway_method.post_employee_data.http_method
  status_code = 200

  # This is where the configuration for CORS enabling starts.
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration" "integration_post_employee_data" {
  rest_api_id             = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id             = aws_api_gateway_resource.employee_resource.id
  http_method             = aws_api_gateway_method.post_employee_data.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.employee_lamda.invoke_arn
}

################################# GET HTTP Method ####################################

resource "aws_api_gateway_method" "get_employee_data" {
  rest_api_id   = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id   = aws_api_gateway_resource.employee_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "get_employee_data_response_200" {
  rest_api_id = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id = aws_api_gateway_resource.employee_resource.id
  http_method = aws_api_gateway_method.get_employee_data.http_method
  status_code = 200


  # This is where the configuration for CORS enabling starts.

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration" "integration_get_employee_data" {
  rest_api_id             = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id             = aws_api_gateway_resource.employee_resource.id
  http_method             = aws_api_gateway_method.get_employee_data.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.employee_lamda.invoke_arn
}

################################# DELETE HTTP Method ####################################

resource "aws_api_gateway_method" "delete_employee_data" {
  rest_api_id   = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id   = aws_api_gateway_resource.employee_resource.id
  http_method   = "DELETE"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.ID" = true
  }
}

resource "aws_api_gateway_method_response" "delete_employee_data_response_200" {
  rest_api_id = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id = aws_api_gateway_resource.employee_resource.id
  http_method = aws_api_gateway_method.delete_employee_data.http_method
  status_code = 200

  # This is where the configuration for CORS enabling starts.
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration" "integration_delete_employee_data" {
  rest_api_id             = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id             = aws_api_gateway_resource.employee_resource.id
  http_method             = aws_api_gateway_method.delete_employee_data.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.employee_lamda.invoke_arn
}

########################################### Employee Gateway Permissions ############################################

resource "aws_lambda_permission" "employee_apigw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.employee_lamda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.employee_api_gw.execution_arn}/*"
}

module "cors" {
  source = "./modules/cors"

  api_id            = aws_api_gateway_rest_api.employee_api_gw.id
  api_resource_id   = aws_api_gateway_resource.employee_resource.id
  allow_credentials = true
}

resource "aws_api_gateway_deployment" "employee_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.employee_api_gw.id
  triggers = {
    redeployment = sha1(jsonencode([

      aws_api_gateway_resource.employee_resource,
      aws_api_gateway_method.post_employee_data,
      aws_api_gateway_integration.integration_post_employee_data,
      aws_api_gateway_method.get_employee_data,
      aws_api_gateway_integration.integration_get_employee_data,
      aws_api_gateway_method.delete_employee_data,
      aws_api_gateway_integration.integration_delete_employee_data,
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_api_gateway_stage" "stage-andon-api" {
  deployment_id = aws_api_gateway_deployment.employee_api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.employee_api_gw.id
  stage_name    = "dev"
}
