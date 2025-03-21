output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_subnets" {
  value = data.aws_subnets.default.ids
}

