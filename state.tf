terraform {
  required_providers {
    aws = {
      version = "~> 4.11.0"
    }
  }

  backend "s3" {
    bucket = "cloudzsh-playground-terraform-state"
    key    = "playground.state"
    region = "ap-south-1"
  }
}