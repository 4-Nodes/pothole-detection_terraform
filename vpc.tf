
resource "aws_vpc" "pothole_detection_vpc" {
  cidr_block           = var.vpc_cidr_block
    assign_generated_ipv6_cidr_block = true

  tags = {
    project = var.tag
  }
}

resource "aws_internet_gateway" "pothole_detection_igw" {
  vpc_id = aws_vpc.pothole_detection_vpc.id

  tags = {
    project = var.tag
  }
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

  tags = {
    project = var.tag
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
