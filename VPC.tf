provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "Tobis_VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tobis-vpc"
  }
}


resource "aws_subnet" "privs" {
  count = length(local.azs)

  vpc_id            = aws_vpc.Tobis_VPC.id
  cidr_block        = local.private_subnets[count.index]
  availability_zone = local.azs[count.index]
  tags = {
    Name = local.private_subnet_names[count.index]
  }
}


resource "aws_subnet" "publs" {
  count = length(local.azs) # 3 ,Index:  Je nach Iteration: 0, 1, 2 

  vpc_id                  = aws_vpc.Tobis_VPC.id
  cidr_block              = local.public_subnets[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = local.public_subnet_names[count.index]
  }
}

locals {
  azs                  = ["eu-central-1a", "eu-central-1b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.3.0/24", "10.0.4.0/24"]
  private_subnet_names = ["private-subnet-1a", "private-subnet-1b"]
  public_subnet_names  = ["public-subnet-1a", "public-subnet-1b"]
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Tobis_VPC.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.Tobis_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


resource "aws_route_table_association" "public_rta" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}



