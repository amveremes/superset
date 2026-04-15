# Deploy infrastructure on AWS using Terraform

```bash
tofu init
tofu apply -var="domain_name=example.com" -var="allowed_cidr_blocks=[\"0.0.0.0/0\"]"
```

# Execute playbook

```bash
ansible-playbook -i inventory.yaml playbooks/superset.yaml --limit default -e@output.json
```
