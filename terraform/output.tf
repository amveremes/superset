# output.tf

resource "local_file" "output_json" {
  filename = "${path.module}/output.json"
  content = jsonencode({
    instance_id = aws_instance.superset.id
    public_ip   = aws_instance.superset.public_ip
    vpc_id      = data.aws_vpc.default.id
    subnet_ids  = data.aws_subnets.private.ids
    db_endpoint = aws_db_instance.postgres.address
  })
  file_permission = "0640"
}

output "ansible_output_json_path" {
  value = local_file.output_json.filename
}

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