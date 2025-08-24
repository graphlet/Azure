Terraform defines Azure resources for this Function App. Use **modules** for reuse.

### Steps

```bash
cd infra
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

Create a remote state backend first (recommended), e.g.:

```bash
../scripts/init_terraform_backend.sh tfstate-rg westeurope mystate123 tfstate
# then edit backend.tf with the printed values and re-run terraform init -reconfigure
```
