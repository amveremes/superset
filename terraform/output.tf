# output.tf

resource "local_file" "output_json" {
  filename = "${path.module}/output.json"
  content = jsonencode({
    instance_id    = aws_instance.superset.id
    public_ip      = aws_eip.superset_eip.public_ip
    domain_name    = var.domain_name
    db_endpoint    = aws_db_instance.postgres.address
    db_user        = var.db_username
    db_password    = var.db_password
    secret_key     = random_password.secret_key.result
    db_table       = var.db_table
    cache_endpoint = aws_elasticache_cluster.superset.cache_nodes[0].address
  })
  file_permission = "0640"
}

output "instance_id" {
  value = aws_instance.superset.id
}

output "public_ip" {
  value = aws_eip.superset_eip.public_ip
}
# RDS endpoint
output "db_endpoint" {
  value = aws_db_instance.postgres.address
}
# RDS db_user
output "db_user" {
  value = var.db_username
}
# RDS password
output "db_password" {
  value = var.db_password
}
# ElastiCache endpoint
output "cache_endpoint" {
  value = aws_elasticache_cluster.superset.cache_nodes[0].address
}

output "secret_key" {
  value = random_password.secret_key.result
}
