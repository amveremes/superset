# variables.tf

variable "aws_region" {
  description = "The AWS region where resources will be provisioned."
  type        = string
  default     = "eu-west-3"
}

variable "aws_profile" {
  description = "The AWS profile where resources will be provisioned."
  type        = string
  default     = "bacasable"
}

variable "ssh_key_pub" {
  description = "The public SSH key to access the EC2 instance."
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC62ZHuajPwcP1BZP6z+vneo/GEv2RE8lWWg520B5tCbX5+bY2NkQ2nWbmR+ZgoQ1fHYC3Do90t7JPuX8eSjK8woA64zYRFF3NU6XYa9kQ2/658ShnYFa+YSnAZ96QDiXC0fX+8ZC562yegwZkgZx/qE4SHfdsrQHtNNubXZlsQhG7MZRkQumw2jGGmIzvd7bIEkJNXRoeEAPyCRoArrEDLFe3w287jhRQWs28958gnV8Ho2hTKCkFc6t5qHiZL2enB4gkHw0xUWOzUrr7v+g4hO7SMeSg1EFgCHt8nD0lXCpiStSIfvE1gbYWYnqRrgfQpn/IsXdldaV1mh8zIMxzb superset_ssh_key"
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access RDS"
  type        = list(string)
  default     = ["81.250.156.186/32"]
}

variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default     = "superset"
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "17.6"
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "The allocated storage for the RDS instance"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "superset"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "superset"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "superset"
}

variable "max_allocated_storage" {
  description = "The maximum allocated storage for the RDS instance"
  type        = number
  default     = 100
}

variable "cache_node_type" {
  description = "The node type for the ElastiCache cluster"
  type        = string
  default     = "cache.t4g.micro"
}
