resource "aws_key_pair" "Chase" {
  key_name   = "Chase-key"
  public_key = var.public_key
}

resource "aws_instance" "Chase" {
  ami           = "ami-0dfcb1ef8550277af"
  instance_type = var.instance_type
  key_name = aws_key_pair.Chase.id
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  availability_zone = var.availability_zone
  associate_public_ip_address = true
  user_data = file("entry-script.sh")
  tags = {
    Name = "Chase"
  }
}