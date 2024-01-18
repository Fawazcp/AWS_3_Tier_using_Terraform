terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "remote" {
    organization = "devopswithlasantha"

    workspaces {
      name = "3tierapptf-workspace"
    }
  }
}


provider "aws" {
  region = "us-east-2"
}