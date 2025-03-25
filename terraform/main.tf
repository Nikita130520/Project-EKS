# Create IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "jenkins-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create IAM Role for EKS Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "jenkins-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Create Security Group
resource "aws_security_group" "eks_sg" {
  name        = "eks_security_group"
  description = "Security group allowing all traffic for debugging"
  vpc_id      = "vpc-02ed5a76fdcf53cf0"

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

# Create EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "jenkins-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = "vpc-02ed5a76fdcf53cf0"
  cluster_role_arn = aws_iam_role.eks_cluster_role.arn

  subnet_ids = [
    "subnet-0190bf6903dea0c87",
    "subnet-02dc6d86a5bf19dbb"
  ]

  cluster_security_group_id = aws_security_group.eks_sg.id

  eks_managed_node_groups = {
    eks_nodes = {
      desired_size  = 2
      max_size      = 3
      min_size      = 1
      instance_types = ["t3.medium"]
      iam_role_arn  = aws_iam_role.eks_node_role.arn

      node_security_group_tags = {
        "eks_sg" = aws_security_group.eks_sg.id
      }
    }
  }
}
