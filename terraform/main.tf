# 🛡️ Security Group to allow all traffic (for testing only)
resource "aws_security_group" "eks_sg" {
  name        = "eks_security_group"
  description = "Security group allowing all traffic"
  vpc_id      = "vpc-0658fa45bcc2e39ea"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0" # Use the latest major version
  cluster_name    = "jenkins-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = "vpc-0658fa45bcc2e39ea"

  subnet_ids = [
    "subnet-012cb82e5506bf371",
    "subnet-0cbb78f21d006b468"
  ]

  cluster_security_group_id = aws_security_group.eks_sg.id

  eks_managed_node_groups = {
    eks_nodes = {
      desired_size     = 2
      max_size         = 3
      min_size         = 1
      instance_types   = ["t3.medium"]

      node_security_group_tags = {
        "eks_sg" = aws_security_group.eks_sg.id
      }
    }
  }

  # ✅ Enable aws-auth management
  manage_aws_auth_configmap = true

  # ✅ Add IAM role to Kubernetes access
  # If you're using an EC2 instance with an IAM role:
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::768343849409:role/AdminRole"  # Change to your EC2 role
      username = "admin"
      groups   = ["system:masters"]
    }
  ]

  # ✅ Or if you're using root user (not recommended but for your case)
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::768343849409:root"
      username = "root"
      groups   = ["system:masters"]
    }
  ]
}
