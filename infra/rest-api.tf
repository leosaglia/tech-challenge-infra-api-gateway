data "aws_cognito_user_pool" "user_pool" {
  user_pool_id = "us-east-1_G4qq9HKiL"
}

data "template_file" "api_template" {
  template = file("${path.module}/openapi/fast-food-tech-challenge-definition.json")

  vars = {
    vpc_link_base_url       = "http://${data.aws_lb.nlb.dns_name}:3001"
    vpc_link_id             = aws_api_gateway_vpc_link.vpc_link.id
    cognito_arn             = data.aws_cognito_user_pool.user_pool.arn,
    authorizer_uri          = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${data.aws_lambda_function.lambda_authorizer.arn}/invocations"
    role_for_authorizer_arn = data.aws_iam_role.role.arn
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name = "fast-food-tech-challenge"
  description = "API for Fast Food Tech Challenge"

  body = data.template_file.api_template.rendered
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ aws_api_gateway_rest_api.api ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"

  depends_on = [ aws_api_gateway_deployment.deployment ]
}