# https://registry.terraform.io/providers/hashicorp/aws/latest/docs

terraform {
  required_version = ">=1.5.1"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}