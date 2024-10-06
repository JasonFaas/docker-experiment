# Create a Network ACL for the subnet
resource "aws_network_acl" "public_subnet_nacl" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1025
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1025
    to_port    = 65535
  }

  # Add additional ingress and egress rules as needed

  tags = {
    Name = "eks-public-subnet-nacl"  # Add a descriptive name for your network ACL
  }
}

# Associate the Network ACL with the subnet
resource "aws_network_acl_association" "public_subnet_nacl_association" {
  count = 2 # TODO: Extract this out as a lot of resources depends on it

  subnet_id      = aws_subnet.public_subnet[count.index].id
  network_acl_id = aws_network_acl.public_subnet_nacl.id
}

# Create a Security Group for the EKS nodes
resource "aws_security_group" "eks_nodes_sg" {
  name        = "eks-nodes-sg"  # Add a descriptive name for your security group
  description = "Security group for EKS nodes"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow inbound traffic from the VPC CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = [data.aws_vpc.default.cidr_block]  # Replace with your VPC CIDR
  }

  egress {
    description = "Allow outbound traffic to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  # Add additional ingress and egress rules as needed

  tags = {
    Name = "eks-nodes-sg"  # Add a descriptive name for your security group
  }
}
