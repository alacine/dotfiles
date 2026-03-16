## My VMs configuration in PVE

```bash
terraform apply
```

terraform.tfvars
```hcl
pm_endpoint         = "https://192.168.88.100:8006/"
pm_api_token_id     = "xxx@xxx"
vm_template_id      = 101 # TODO: replace with actual VMID of template
pm_api_token_secret = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
vm_user             = "xxxx"
vm_password         = "xxxxxxxx"
public_key_path     = "~/.ssh/id_rsa.pub"
private_key_path    = "~/.ssh/id_rsa"
```
