# cache.tf

# Subnet group for ElastiCache
resource "aws_elasticache_subnet_group" "main" {
  name       = "cache-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    ManagedBy = "terraform"
  }
}

# Security group for ElastiCache
resource "aws_security_group" "cache" {
  name_prefix = "cache-"
  vpc_id      = data.aws_vpc.public.id
  description = "Security group for ElastiCache"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    #security_groups = [ec2_security_group.id]
    description = "Redis from application"
  }

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.superset_sg.id]
    description     = "Redis from Superset EC2"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_cluster" "superset" {
  cluster_id           = "superset-cluster"
  engine               = "redis"
  node_type            = var.cache_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  apply_immediately    = true
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.cache.id]

  tags = {
    Name   = "Superset Cache"
    Source = "terraform"
  }
}
