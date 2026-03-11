## My VMs configuration in PVE

```bash
terraform apply
```

terraform.tfvars
```hcl
pm_api_url          = "xxxx"
pm_user             = "xxxx"
pm_api_token_id     = "xxxx"
pm_api_token_secret = "xxxx"
vm_user             = "xxxx"
public_key_path     = "~/.ssh/id_rsa.pub"
private_key_path    = "~/.ssh/id_rsa"
```
