resource "aws_vpc" "dove" {
  cidr_block           = "172.20.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dove-vpc"
  }
}

resource "aws_subnet" "dove-pub-1" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "172.20.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "dove-pub-1"
  }
}


resource "aws_subnet" "dove-priv-1" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "172.20.20.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "dove-priv-1"
  }
}


resource "aws_internet_gateway" "dove-IGW" {
  vpc_id = aws_vpc.dove.id
  tags = {
    Name = "dove-IGW"
  }
}

resource "aws_route_table" "dove-pub-RT" {
  vpc_id = aws_vpc.dove.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dove-IGW.id
  }

  tags = {
    Name = "dove-pub-RT"
  }
}



resource "aws_route_table" "dove-pvt-RT" {
  vpc_id = aws_vpc.dove.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "aws_nat_gateway.nat.id"
  }

  tags = {
    Name = "dove-pub-RT"
  }
}



resource "aws_route_table_association" "dove-pub-1-a" {
  subnet_id      = aws_subnet.dove-pub-1.id
  route_table_id = aws_route_table.dove-pub-RT.id
}

#private subnet
#resource "aws_route_table_association" "dove-pvt-1-a" {
 # subnet_id      = aws_subnet.dove-priv-1.id
 # route_table_id = aws_route_table.dove-dove-pvt-RT.id
#}



# Create the NAT Gateway
resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.dove-pub-1.id
  allocation_id = aws_eip.nat.id
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}
