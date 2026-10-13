terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket  = "deploy-terraform-s3-state"
    key     = "deploy-s3-bucket/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

data "aws_caller_identity" "current" {}
