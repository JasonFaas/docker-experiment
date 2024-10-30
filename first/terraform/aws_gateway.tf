# # Public Route Table and Route for Internet Gateway
# resource "aws_route_table" "public_route_table" {
#   vpc_id = data.aws_vpc.default.id
#   tags = {
#     Name = "eks-public-route-table"
#   }
# }

resource "aws_route_table_association" "public_subnet_assoc" {
  count = length(aws_subnet.public_subnet[*].id)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = data.aws_vpc.default.main_route_table_id
}

# resource "aws_eip" "nat_eip" {
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id  # Elastic IP for the NAT Gateway
#   subnet_id     = aws_subnet.public_subnet[0].id  # Public subnet ID
#   connectivity_type = "public"
#
#   tags = {
#     Name = "nat-gateway"
#   }
# }
#
# resource "aws_route_table" "public_route_table" {
#   vpc_id = data.aws_vpc.default.id
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat_gateway.id  # NAT Gateway ID
#   }
#
#   tags = {
#     Name = "public-route-table"
#   }
# }
#
# resource "aws_route_table_association" "public_subnet_association" {
#   count = length(aws_subnet.public_subnet[*].id)  # If you have multiple subnets
#
#   subnet_id      = aws_subnet.public_subnet[count.index].id  # Public subnet IDs
#   route_table_id = aws_route_table.public_route_table.id     # Public route table
# }