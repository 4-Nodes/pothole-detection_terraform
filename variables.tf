variable "region" {
  description = "AWS Region"
}

variable "az_a" {
  description = "Availablity Zone A"
}

variable "az_b" {
  description = "Availablity Zone B"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
}

variable "db_subnet_a" {
  description = "Subnet for the DB instance that'll be in AZ A"
}

variable "ecs_subnet_a" {
  description = "Subnet for ECS in AZ A"
}

variable "reserved_subnet_a" {
  description = "Reserved subnet range in AZ A"
}

variable "gw_subnet_a" {
  description = "Subnet for API Gateway in AZ A"
}

variable "db_subnet_b" {
  description = "Subnet for the DB instance that'll be in AZ B"
}

variable "ecs_subnet_b" {
  description = "Subnet for ECS in AZ B"
}

variable "gw_subnet_b" {
  description = "Subnet for API Gateway in AZ B"
}

variable "reserved_subnet_b" {
  description = "Reserved subnet range in AZ B"
}
