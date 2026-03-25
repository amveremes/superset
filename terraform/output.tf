# output.tf


output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "subnet_id" {
  value = data.aws_subnets.private.ids
}

output "instance_id" {
  value = aws_instance.superset.id
}

output "public_ip" {
  value = aws_instance.superset.public_ip
}