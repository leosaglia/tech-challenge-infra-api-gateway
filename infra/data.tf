data "aws_lb" "nlb" {
  tags = {
    "kubernetes.io/service-name" = "default/tech-challenge-fast-food-api-service"
  }
}

data "aws_iam_role" "role" {
  name = "LabRole"
}

data "aws_lambda_function" "lambda_authorizer" {
  function_name = "tech-challenge-authorizer"
}