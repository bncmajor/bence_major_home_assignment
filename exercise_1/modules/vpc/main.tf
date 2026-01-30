resource "aws_vpc" "main" {
  region = var.region
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc_endpoint" "s3" {
    vpc_id = aws_vpc.main.id
    vpc_endpoint_type = "Gateway"
    service_name = "com.amazonaws.${var.region}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  for_each = var.private_subnets
  route_table_id  = aws_route_table.private[each.key].id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
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
  for_each = var.private_subnets
  subnet_id = aws_subnet.private[each.key].id
}

resource "aws_route_table" "private" {
  for_each = var.private_subnets
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[each.key].id
  }

  tags = {
    Name = "rt-private"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}


resource "aws_security_group" "load_balancer_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_security_group" app_server_sg {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



