resource "aws_subnet" "pothole_detection_db_subnet_a" {
  vpc_id = aws_vpc.pothole_detection_vpc.id
  cidr_block = var.db_subnet_a
  availability_zone = var.az_a
}

resource "aws_subnet" "pothole_detection_db_subnet_b" {
  vpc_id = aws_vpc.pothole_detection_vpc.id
  cidr_block = var.db_subnet_b
  availability_zone = var.az_b
}

resource "aws_subnet" "pothole_detection_ecs_subnet_a" {
  vpc_id = aws_vpc.pothole_detection_vpc.id
  cidr_block = var.ecs_subnet_a
  availability_zone = var.az_a
}

resource "aws_subnet" "pothole_detection_ecs_subnet_b" {
  vpc_id = aws_vpc.pothole_detection_vpc.id
  cidr_block = var.ecs_subnet_b
  availability_zone = var.az_b
}

resource "aws_subnet" "pothole_detection_gw_subnet_a" {
  vpc_id = aws_vpc.pothole_detection_vpc.id
  cidr_block = var.gw_subnet_a
  availability_zone = var.az_a
  map_public_ip_on_launch = true
}

resource "aws_subnet" "pothole_detection_gw_subnet_b" {
    vpc_id = aws_vpc.pothole_detection_vpc.id
    cidr_block = var.gw_subnet_b
    availability_zone = var.az_b
    map_public_ip_on_launch = true
}

resource "aws_subnet" "pothole_detection_reserved_subnet_a" {
  vpc_id = aws_vpc.pothole_detection_vpc.id
  cidr_block = var.reserved_subnet_a
  availability_zone = var.az_a
}

resource "aws_subnet" "pothole_detection_reserved_subnet_b" {
  vpc_id = aws_vpc.pothole_detection_vpc.id
  cidr_block = var.reserved_subnet_b
  availability_zone = var.az_b
}
