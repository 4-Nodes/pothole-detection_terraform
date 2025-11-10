terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "pd-terraform-state-bucket"
    key            = "pothole-detection/terraform.tfstate"
    region         = "af-south-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
