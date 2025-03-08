terraform {
  backend "s3" {
    bucket = "state-terraform-tech"
    key = "tech-challenge-infra-api-gateway/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}