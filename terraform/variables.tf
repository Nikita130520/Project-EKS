variable "aws_region" {
  default = "ap-south-1"
}

variable "cluster_name" {
  default = "jenkins-eks-cluster"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "desired_capacity" {
  default = 2
}

variable "max_capacity" {
  default = 3
}

variable "min_capacity" {
  default = 1
}

