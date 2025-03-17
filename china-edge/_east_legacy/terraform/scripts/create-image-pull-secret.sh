export KUBECONFIG=china-edge/terraform/.env/kubeconfig
source china-edge/terraform/.env/var.container-registry

kubectl create secret docker-registry streamx-demo-pull-secret \
  --docker-server=crpi-ynub1f3ynqwgpy46.cn-hangzhou.personal.cr.aliyuncs.com \
  --docker-username=$REGISTRY_USERNAME \
  --docker-password=$REGISTRY_PASSWORD \
  --docker-email=$REGISTRY_USERNAME

kubectl create secret docker-registry streamx-demo-pull-secret \
  --docker-server=crpi-ynub1f3ynqwgpy46.cn-hangzhou.personal.cr.aliyuncs.com \
  --docker-username=$REGISTRY_USERNAME \
  --docker-password=$REGISTRY_PASSWORD \
  --docker-email=$REGISTRY_USERNAME \
  -n ingress-apisix

kubectl create secret docker-registry streamx-demo-pull-secret \
  --docker-server=crpi-ynub1f3ynqwgpy46.cn-hangzhou.personal.cr.aliyuncs.com \
  --docker-username=$REGISTRY_USERNAME \
  --docker-password=$REGISTRY_PASSWORD \
  --docker-email=$REGISTRY_USERNAME \
  -n streamx-operator

# kubectl get secret streamx-demo-pull-secret --output=yaml