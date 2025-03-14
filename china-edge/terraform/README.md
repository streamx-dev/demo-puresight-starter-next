Terraform module for creating Kubernetes Cluster on Alibaba Cloud.
=====================================================================

## Usage

Create Kubernetes Configuration file under `.env/kubeconfig`.
The cluster can be created using the console: https://acs.console.aliyun.com/

The image registry can be created using: https://cr.console.aliyun.com/repository/cn-hangzhou/
Put credentials to the Container registry to `.env/container.registry` folder.

Execute scripts from `./scripts` directory to setup registry images (you may need to create namespaces).

To run this example you need to execute:

```bash
source .env/var.terraform

$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Configuring Kubernetes Config

To use Kubernetes Configuration in your shell, use the following command:

```bash
export KUBECONFIG=.env/kubeconfig
```
