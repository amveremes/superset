# Deploy infrastructure on AWS using Terraform

```bash
terraform apply
```

# Execute playbook

```bash
ansible-playbook -i inventory.yaml playbooks/superset.yaml --limit default -e@output.json
```
