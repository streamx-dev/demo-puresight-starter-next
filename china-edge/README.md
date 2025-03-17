# StreamX Multi-cluster setup

## Locations: 
- east - China (Edge cluster)
- west - US (Master cluster)

## Configure Kubernetes
Put Kubernetes configuration files to

`china/terraform/.env/kubeconig`
and 
`us/terraform/.env/kubeconfig`

## Install StreamX on both clusters:
Follow README instructions:
Infrastructure setup: `china/terraform/README.md`
Mesh setup: `china/README.md`

Infrastructure setup: `us/terraform/README.md`
Mesh setup: `us/README.md`

## Connect clusters using Linkerd
Follow instructions from `linkerd`