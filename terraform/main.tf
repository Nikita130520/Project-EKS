module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "example"
  cluster_version = "1.33"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = "vpc-0658fa45bcc2e39ea"
  subnet_ids = ["subnet-012cb82e5506bf371", "subnet-0cbb78f21d006b468", "subnet-06a9bfbd7edeff98a"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
