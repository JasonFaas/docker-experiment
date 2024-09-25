
resource "aws_iam_role" "first_eks_role" {
  name = "first-eks-role"

  description           = "Allows access to other AWS service resources that are required to operate clusters managed by EKS."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}


resource "aws_eks_cluster" "first_test" {
  name = local.eks_cluster_name
  role_arn = aws_iam_role.first_eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.private_subnet[*].id
    endpoint_private_access   = true
    endpoint_public_access = false
    public_access_cidrs       = ["0.0.0.0/0", ]
    security_group_ids        = []
  }

  bootstrap_self_managed_addons = false
  enabled_cluster_log_types = []

#   access_config {
#     authentication_mode                         = "API_AND_CONFIG_MAP"
#     bootstrap_cluster_creator_admin_permissions = true
#   }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "10.100.0.0/16"
  }

  upgrade_policy {
    support_type = "STANDARD"
  }
}

# Define an EKS Node Group to add EC2 instances
resource "aws_eks_node_group" "node_group" {
  timeouts {
    create = "10m"
  }

  cluster_name    = aws_eks_cluster.first_test.name  # Refer to your EKS cluster
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn   # IAM role for the EC2 nodes
  subnet_ids      = aws_subnet.private_subnet[*].id

  scaling_config {
    desired_size = 2  # Number of nodes you want
    max_size     = 2  # Maximum number of nodes
    min_size     = 1  # Minimum number of nodes
  }

  instance_types = ["t3.medium"]  # Medium-sized EC2 instances

  ami_type = "AL2_x86_64"  # Amazon Linux 2 AMI for x86

  disk_size = 20  # Size of EBS volume attached to the instances (in GB)

  labels = {
    env = "prod"
  }

  tags = {
    Name = "eks-node-group"
  }
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attach necessary policies to the Node Group Role
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}