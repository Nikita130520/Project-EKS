module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8" # ✅ ensure you're using v20 or higher

  cluster_name    = "jenkins-eks-cluster"
  cluster_version = "1.31"
  vpc_id          = "vpc-0658fa45bcc2e39ea"
  subnet_ids = [
    "subnet-012cb82e5506bf371",
    "subnet-0cbb78f21d006b468"
  ]

  cluster_security_group_id        = aws_security_group.eks_sg.id
  cluster_endpoint_public_access   = true
  cluster_endpoint_private_access  = false

  # ✅ This enables Terraform to manage the aws-auth configmap
  manage_aws_auth_configmap = true

  
  

  
  eks_managed_node_groups = {
    eks_nodes = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]

      node_security_group_tags = {
        "eks_sg" = aws_security_group.eks_sg.id
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "jenkins-eks"
  }
}

resource "aws_security_group" "eks_sg" {
  name        = "eks_security_group"
  description = "Security group allowing all traffic for debugging"
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
