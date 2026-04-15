# secret.tf

resource "random_password" "secret_key" {
  length  = 64
  special = true
}
