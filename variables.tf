variable "region" {
  default = "af-south-1"
}

variable "az_a" {
  default = "af-south-1a"
}

variable "az_b" {
  default = "af-south-1a"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/24"
}

variable "db_subnet_a" {
  default = "10.0.0.0/27"
}

variable "ecs_subnet_a" {
  default = "10.0.0.32/27"
}

variable "reserved_subnet_a" {
  default = "10.0.0.96/27"
}

variable "gw_subnet_a" {
  default = "10.0.0.64/27"
}

variable "db_subnet_b" {
  default = "10.0.0.128/27"
}

variable "ecs_subnet_b" {
  default = "10.0.0.160/27"
}

variable "gw_subnet_b" {
  default = "10.0.0.192/27"
}

variable "reserved_subnet_b" {
  default = "10.0.0.224/27"
}
