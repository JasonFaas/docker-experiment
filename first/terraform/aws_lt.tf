# Create a launch template for the EKS nodes
resource "aws_launch_template" "eks_nodes_launch_template" {
  name          = "eks-nodes-launch-template-standard"  # Add a descriptive name for your launch template

  block_device_mappings {
    device_name  = "/dev/xvda"
    ebs {
      delete_on_termination = true
      # encrypted = true
#       kms_key_id = ""
      volume_size = 50  # Adjust the volume size as needed
      iops        = 200  # Adjust the IOPS as needed
      volume_type = "gp3"
    }
  }

  user_data = base64encode(<<EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==BOUNDARY=="

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${aws_eks_cluster.eks_cluster.name} \
  --kubelet-extra-args '--eviction-hard=memory.available<200Mi,nodefs.available<10%,nodefs.inodesFree<5%' \
  --kubelet-extra-args '--eviction-soft=memory.available<500Mi,nodefs.available<15%,nodefs.inodesFree<10%' \
  --kubelet-extra-args '--eviction-soft-grace-period=memory.available=1m,nodefs.available=1m,nodefs.inodesFree=1m' \
  --kubelet-extra-args '--eviction-max-pod-grace-period=30'

--==BOUNDARY==--
EOF
  )

  metadata_options {
    http_endpoint = "enabled"
    http_put_response_hop_limit = 2
    http_tokens = "optional"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "eks-nodes"  # Add a descriptive name for your instances
    }
  }
}