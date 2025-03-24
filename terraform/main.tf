module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "jenkins-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = "vpc-02ed5a76fdcf53cf0"

  subnet_ids = [
    "subnet-0190bf6903dea0c87",
    "subnet-02dc6d86a5bf19dbb"
  ]


  eks_managed_node_groups = {
    eks_nodes = {
      desired_size  = 2
      max_size      = 3
      min_size      = 1
      instance_types = ["t3.medium"]
    }
  }
}
