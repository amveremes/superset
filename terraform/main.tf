# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# filter private vpc created by vCloud
data "aws_subnets" "private" {
  tags = {
    Name    = "vcloud-veremes-*"
    Source  = "vCloud"
    Network = "private"
  }
}

# select one AWS Subnet
data "aws_subnet" "private" {
  id = data.aws_subnets.private.ids[0]
}

# select vpc of default subnet
data "aws_vpc" "default" {
  id = data.aws_subnet.private.vpc_id
}

# filter public vpc created by vCloud
data "aws_subnets" "public" {
  tags = {
    Name    = "vcloud-veremes-*"
    Source  = "vCloud"
    Network = "public"
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "public" {
  id = data.aws_subnets.public.ids[0]
}

data "aws_vpc" "public" {
  id = data.aws_subnet.public.vpc_id
}
