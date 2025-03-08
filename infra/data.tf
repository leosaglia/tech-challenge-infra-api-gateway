data "aws_lb" "nlb" {
  tags = {
    "kubernetes.io/service-name" = "default/tech-challenge-fast-food-api-service"
  }
}