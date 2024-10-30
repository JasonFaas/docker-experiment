
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

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
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}


resource "aws_eks_cluster" "eks_cluster" {
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore,
    aws_route_table_association.public_subnet_assoc,
    aws_route.public_route,
  ]

  name = local.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  version = local.eks_version

  vpc_config {
    subnet_ids = aws_subnet.public_subnet[*].id
    endpoint_private_access   = true
    endpoint_public_access = true
    public_access_cidrs       = ["0.0.0.0/0", ]
    security_group_ids        = [aws_security_group.eks_nodes_sg.id]
  }

  bootstrap_self_managed_addons = false
  enabled_cluster_log_types = []

#   access_config {
#     authentication_mode                         = "API_AND_CONFIG_MAP"
#     bootstrap_cluster_creator_admin_permissions = true
#   }

  # kubernetes_network_config {
  #   ip_family         = "ipv4"
  #   service_ipv4_cidr = "10.100.0.0/16"
  # }

  upgrade_policy {
    support_type = "STANDARD"
  }
}

# Define an EKS Node Group to add EC2 instances
resource "aws_eks_node_group" "node_group" {
  timeouts {
    create = "10m"
  }

  release_version = "${local.eks_version}.4-20240928" # https://github.com/awslabs/amazon-eks-ami/releases
  version = local.eks_version
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name_prefix = "eks-node-group-"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.public_subnet[*].id

  launch_template {
    version = aws_launch_template.eks_nodes_launch_template.latest_version
    id = aws_launch_template.eks_nodes_launch_template.id
  }

  scaling_config {
    desired_size = 2  # Number of nodes you want
    max_size     = 2  # Maximum number of nodes
    min_size     = 1  # Minimum number of nodes
  }

  instance_types = ["t3.medium"]  # Medium-sized EC2 instances

#   ami_type = local.ami

#   disk_size = 20  # Size of EBS volume attached to the instances (in GB)

  labels = {
    env = "prod"
  }

  lifecycle {
    create_before_destroy = false # TODO: Set back to true after it is working.
  }

  tags = {
    Name = "eks-node-group",
    "k8s.io/cluster-autoscaler/enabled" = "true",
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.eks_cluster.name}" = "owned",
    "Service" = "EKS worker node",
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

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  # policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy" # TODO: Is it supposed to be this?
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}