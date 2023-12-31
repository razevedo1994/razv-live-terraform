resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "live-terraform-vpc"
  }
}

resource "aws_subnet" "this" {
  vpc_id                    = aws_vpc.this.id
  cidr_block                = "10.0.0.0/24"
  availability_zone         = "us-east-1a"
  map_public_ip_on_launch   = false

  tags = {
    name = "live-terraform-subnet"
  }
}

resource "aws_security_group" "this" {
  name          = "live-terraform-sg"
  description   = "Security group for Lambda function"

  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "MainInternetGateway"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.us-east-1.s3"

  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.this.id]
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}