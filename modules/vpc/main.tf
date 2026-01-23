resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# resource "aws_subnet" "public_subnet" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "Main"
#   }
# }

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24" # Choose an unused block inside your VPC
  map_public_ip_on_launch = true           # REQUIRED: Automatically assigns public IPs
  availability_zone       = "eu-north-1a"  # Pick an AZ in your region

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}