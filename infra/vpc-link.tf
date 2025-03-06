resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "fast-food-nlb"
  description = "VPC Link para conectar o API GTW ao NLB"
  target_arns = ["criar-um-nlb-e-colocar-o-arn-aqui"]
}