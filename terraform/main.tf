# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch the default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnets         = data.aws_subnets.default.ids
  vpc_id          = data.aws_vpc.default.id

  node_groups = {
    eks_nodes = {
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity
      instance_types   = [var.node_instance_type]
    }
  }
}

