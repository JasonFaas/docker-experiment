# Create a Network ACL for the private subnet
resource "aws_network_acl" "private_subnet_nacl" {
  vpc_id = aws_vpc.your_vpc_id  # Replace with your VPC ID

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
    Name = "eks-private-subnet-nacl"  # Add a descriptive name for your network ACL
  }
}

# Associate the Network ACL with the private subnet
resource "aws_network_acl_association" "private_subnet_nacl_association" {
  subnet_id      = aws_subnet.private_subnet.id  # Replace with your private subnet ID
  network_acl_id = aws_network_acl.private_subnet_nacl.id
}

# Create a Security Group for the EKS nodes
resource "aws_security_group" "eks_nodes_sg" {
  name        = "eks-nodes-sg"  # Add a descriptive name for your security group
  description = "Security group for EKS nodes"
  vpc_id      = aws_vpc.your_vpc_id  # Replace with your VPC ID

  ingress {
    description = "Allow inbound traffic from the VPC CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = [aws_vpc.your_vpc_id.cidr_block]  # Replace with your VPC CIDR
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

# TODO: Look up this part as the field doesn't look right
# Modify the EKS Node Group resource to use the newly created security group
resource "aws_eks_node_group" "node_group" {
  # ... other configurations ...

  security_group_ids = [aws_security_group.eks_nodes_sg.id]  # Replace with your security group ID

  # ... other configurations ...
}