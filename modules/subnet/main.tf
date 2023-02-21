resource "aws_subnet" "Chase-subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "Chase-subnet"
  }
}

resource "aws_internet_gateway" "Chase-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Chase-igw"
  }
}

resource "aws_route_table" "Chase-route" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Chase-igw.id
  }

  tags = {
    Name = "Chase-route"
  }
}

resource "aws_route_table_association" "Chase" {
  subnet_id      = aws_subnet.Chase-subnet.id
  route_table_id = aws_route_table.Chase-route.id
}