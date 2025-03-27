
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "jenkins-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = "vpc-02ed5a76fdcf53cf0"
  subnet_ids = [
    "subnet-0190bf6903dea0c87",
    "subnet-02dc6d86a5bf19dbb"
  ]


  # Use custom security group
  cluster_security_group_id = aws_security_group.eks_sg.id


  eks_managed_node_groups = {
    eks_nodes = {
      desired_size  = 2
      max_size      = 3
      min_size      = 1
      instance_types = ["t3.medium"]
    
      # Attach security group to nodes
      node_security_group_tags = {
        "eks_sg" = aws_security_group.eks_sg.id
      }
    }
  }
}

# ✅ Create Security Group with ALL Traffic Allowed
resource "aws_security_group" "eks_sg" {
  name        = "eks_security_group"
  description = "Security group allowing all traffic for debugging"
  vpc_id      = "vpc-02ed5a76fdcf53cf0"

  # Allow ALL inbound traffic from anywhere
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ALL outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks_security_group"
  }
}
