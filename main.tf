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

resource "aws_vpc" "pothole_detection_vpc" {
  cidr_block           = var.vpc_cidr_block
    assign_generated_ipv6_cidr_block = true
}

resource "aws_internet_gateway" "pothole_detection_igw" {
  vpc_id = aws_vpc.pothole_detection_vpc.id
}

resource "aws_route_table" "pothole_detection_rt" {
  vpc_id = aws_vpc.pothole_detection_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pothole_detection_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.pothole_detection_igw.id
  }
}

resource "aws_route_table_association" "pothole_detection_rt_gw_a" {
  subnet_id      = aws_subnet.pothole_detection_gw_subnet_a.id
  route_table_id = aws_route_table.pothole_detection_rt.id
}

resource "aws_route_table_association" "pothole_detection_rt_gw_b" {
    subnet_id      = aws_subnet.pothole_detection_gw_subnet_b.id
    route_table_id = aws_route_table.pothole_detection_rt.id
}
