terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "terraform-3-tier-app-testqa"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-3-tier-app-remote-db"
  }
}


provider "aws" {
  region = "us-west-2"
}