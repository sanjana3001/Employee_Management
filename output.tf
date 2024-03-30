############################ API Url displayed on Output/Console ############################
output "api_url" {
  value = "${aws_api_gateway_deployment.employee_api_deploy.invoke_url}dev/employeeData"

}
############################ The API is saved/exported to a JSON file ############################
resource "null_resource" "create_json_file" {
  triggers = {
    api_url = aws_api_gateway_deployment.employee_api_deploy.invoke_url
  }

  provisioner "local-exec" {
    command = <<EOT
echo '{ "api_url": "${aws_api_gateway_deployment.employee_api_deploy.invoke_url}dev/employeeData" }' >frontend/api_url.json
EOT
  }
}
