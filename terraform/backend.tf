# backend.tf

terraform {
  backend "s3" {
    bucket         = "veremes-tofu-state"
    key            = "exploitation/apache-superset"
    region         = "eu-west-3"
    dynamodb_table = "veremes-tofu-state-locks"
    encrypt        = true
  }
}
