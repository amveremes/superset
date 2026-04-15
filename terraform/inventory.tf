# inventory.tf

locals {
  group_name           = "default"
  ansible_user         = "ubuntu"
  ansible_ssh_key_path = pathexpand("~/.ssh/id_rsa")
}

data "template_file" "inventory_yaml" {
  template = <<-EOT
---
all:
  children:
    ${local.group_name}:
      hosts:
        superset:
          ansible_host: ${aws_eip.superset_eip.public_ip}
          ansible_user: ${local.ansible_user}
          ansible_ssh_private_key_file: ${local.ansible_ssh_key_path}
          ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
EOT
}

resource "local_file" "inventory_yaml" {
  filename = "${path.module}/inventory.yaml"
  content  = trimspace(data.template_file.inventory_yaml.rendered)
}

output "inventory_file_path" {
  value = local_file.inventory_yaml.filename
}
