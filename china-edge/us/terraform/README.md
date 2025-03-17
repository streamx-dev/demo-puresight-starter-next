Terraform module for creating Kubernetes Cluster on Alibaba Cloud.
=====================================================================

## Usage

Create Kubernetes Configuration file under `.env/kubeconfig`.
The cluster can be created using the console: https://acs.console.aliyun.com/

To run this example you need to execute:

```bash
source .env/var.terraform

$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources which cost money. Run `terraform destroy` when you
don't need these resources.
