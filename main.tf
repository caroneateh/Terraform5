resource "aws_vpc" "Chase" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Chase"
  }
}

module "Chase-Subnet" {
  source = "./modules/subnet"
  vpc_id = aws_vpc.Chase.id
  availability_zone = var.availability_zone
  subnet_cidr = var.subnet_cidr
}

module "Chase-SG" {
  source = "./modules/security group"
  vpc_id = aws_vpc.Chase.id
  my_ip = var.my_ip
}

module "Chase-instance" {
  source = "./modules/webserver"
  public_key = var.public_key
  instance_type = var.instance_type
  subnet_id = module.Chase-Subnet.subnet.id
  security_group_id = module.Chase-SG.security.id
  availability_zone = var.availability_zone

}

