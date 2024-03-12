#creating vpc
resource "aws_vpc" "my-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my-vpc"
  }
}
#web subnet
resource "aws_subnet" "my-web-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "my-web-subnet"
  }
}
#internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "gateway"
  }
}
#route table
resource "aws_route_table" "my-route" {
  vpc_id = aws_vpc.my-vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "route"
  }
}
#association route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my-web-subnet.id
  route_table_id = aws_route_table.my-route.id
}