
# Create a Security Group for the EKS nodes
resource "aws_security_group" "eks_nodes_sg" {
  name        = "eks-nodes-sg"  # Add a descriptive name for your security group
  description = "Security group for EKS nodes"
  vpc_id      = data.aws_vpc.default.id

# TODO: Need for ssh access?
  # ingress {
  #   from_port       = 22
  #   to_port         = 22
  #   protocol        = "tcp"
  #   cidr_blocks     = ["0.0.0.0/0"]  # Adjust for SSH access
  # }

  ingress {
    description = "Allow inbound traffic from the VPC CIDR"
    from_port   = 0 # eventually only allow 443
    to_port     = 0 # eventually only allow 443
    protocol    = "-1" # eventually tcp
    cidr_blocks  = ["0.0.0.0/0"]  # [data.aws_vpc.default.cidr_block] TODO: Replace with your VPC CIDR
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
