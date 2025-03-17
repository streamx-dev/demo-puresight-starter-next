source ./china-edge/istio/.env/var.container-registry

kubectl create namespace istio-system

kubectl create secret docker-registry streamx-demo-pull-secret \
  --docker-server=crpi-ynub1f3ynqwgpy46.cn-hangzhou.personal.cr.aliyuncs.com \
  --docker-username=$REGISTRY_USERNAME \
  --docker-password=$REGISTRY_PASSWORD \
  --docker-email=$REGISTRY_USERNAME \
  -n istio-system

# Optional, if using samples
# kubectl create secret docker-registry streamx-demo-pull-secret \
#   --docker-server=crpi-ynub1f3ynqwgpy46.cn-hangzhou.personal.cr.aliyuncs.com \
#   --docker-username=$REGISTRY_USERNAME \
#   --docker-password=$REGISTRY_PASSWORD \
#   --docker-email=$REGISTRY_USERNAME \
#   -n sample