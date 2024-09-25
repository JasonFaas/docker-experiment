resource "aws_eip" "nat_eip" {
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id  # Elastic IP for the NAT Gateway
  subnet_id     = data.aws_subnets.default.ids[0]  # Subnet where NAT Gateway is deployed (public)
  connectivity_type = "public"

  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id  # NAT Gateway ID
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count = length(aws_subnet.private_subnet[*].id)  # If you have multiple private subnets

  subnet_id      = aws_subnet.private_subnet[count.index].id  # Private subnet IDs
  route_table_id = aws_route_table.private_route_table.id     # Private route table
}