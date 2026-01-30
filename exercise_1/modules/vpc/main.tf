resource "aws_vpc" "main" {
  region = var.region
}

resource "aws_vpc_endpoint" "s3" {
    vpc_id = aws_vpc.main.id
    vpc_endpoint_type = "Gateway"
    service_name = "com.amazonaws.${var.region}.s3"
}

resource "aws_subnet" "public" {
    for_each = var.public_subnets
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr_block
    availability_zone = "${var.region}${each.key}"
    

    tags = {
      Name = "subnet-${var.region}${each.key}-public"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "rt-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
    for_each = var.private_subnets
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr_block
    availability_zone = "${var.region}${each.key}"

    tags = {
      Name = "subnet-${var.region}${each.key}-private"
    }
}

resource "aws_nat_gateway" "main" {
  vpc_id = aws_vpc.main.id
  availability_mode = "regional"
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "rt-private"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}




