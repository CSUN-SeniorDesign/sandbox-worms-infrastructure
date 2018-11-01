#import certificate to aws

terraform {
  backend "s3" {
    bucket         = "sandboxworms-rstate-0911218-24"
    region         = "us-east-1"
    dynamodb_table = "sandboxworms-lockdb-09112018-24"
    key            = "terraformPROJ5.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_acm_certificate" "sandboxworms-cert" {
  domain_name       = "sandboxworms.me"
  validation_method = "EMAIL"

  subject_alternative_names = ["*.sandboxworms.me"]
}