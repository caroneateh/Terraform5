resource "aws_vpc" "Chase" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Chase"
  }
}

resource "aws_subnet" "Chase-subnet" {
  vpc_id     = aws_vpc.Chase.id
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "Chase-subnet"
  }
}

resource "aws_internet_gateway" "Chase-igw" {
  vpc_id = aws_vpc.Chase.id
  tags = {
    Name = "Chase-igw"
  }
}

resource "aws_route_table" "Chase-route" {
  vpc_id = aws_vpc.Chase.id

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

resource "aws_security_group" "Chase-SG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Chase.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Chase-SG"
  }
}

resource "aws_key_pair" "Chase" {
  key_name   = "Chase-key"
  public_key = var.public_key
}

resource "aws_instance" "Chase" {
  ami           = "ami-0dfcb1ef8550277af"
  instance_type = var.instance_type
  key_name = aws_key_pair.Chase.id
  subnet_id = aws_subnet.Chase-subnet.id
  vpc_security_group_ids = [aws_security_group.Chase-SG.id]
  availability_zone = var.availability_zone
  associate_public_ip_address = true
  user_data = file("entry-script.sh")
  tags = {
    Name = "Chase"
  }
}

