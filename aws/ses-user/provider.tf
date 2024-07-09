provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "terraform.turai.work"
    region = "ap-northeast-1"
    # profile = "terraform"
    key = "aws/ses-user/terraform.tfstate"
  }
}

