# Create a launch template for the EKS nodes
resource "aws_launch_template" "eks_nodes_launch_template" {
  name          = "eks-nodes-launch-template"  # Add a descriptive name for your launch template
  image_id      = "ami-0a37958d1abd703ea" # Bottlerocket image id - aws ssm get-parameter --name /aws/service/bottlerocket/aws-k8s-1.30/x86_64/latest/image_id
#   instance_type = "t3.medium"  # Replace with the desired instance type

  block_device_mappings {
    device_name  = "/dev/nvme0n1"
    ebs {
      volume_type = "gp3"
      volume_size = 10  # Adjust the volume size as needed
      iops        = 200  # Adjust the IOPS as needed
      delete_on_termination = true
#       encrypted = true
#       kms_key_id = ""
    }
  }

  user_data = base64encode(local.bottlerocket_config)

#   network_interfaces {
#     security_groups = [aws_security_group.eks_nodes_sg.id]  # Replace with the ID of your security group
#     subnet_id       = aws_subnet.private_subnet[0].id  # Replace with the ID of your private subnet
#   }
#
#   user_data_base64 = base64encode(templatefile("${path.module}/user_data.sh", {
#     cluster_name = aws_eks_cluster.your_cluster_name.name  # Replace with the name of your EKS cluster
#   }))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "eks-nodes"  # Add a descriptive name for your instances
    }
  }
}