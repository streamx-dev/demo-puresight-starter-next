CONTAINER_REGISTRY=crpi-ynub1f3ynqwgpy46.cn-hangzhou.personal.cr.aliyuncs.com/streamx-demo

docker pull --platform=linux/amd64 docker.io/istio/proxyv2:1.25.0
docker tag docker.io/istio/proxyv2:1.25.0 ${CONTAINER_REGISTRY}/proxyv2:1.25.0
docker push ${CONTAINER_REGISTRY}/proxyv2:1.25.0

docker pull --platform=linux/amd64 docker.io/istio/pilot:1.25.0
docker tag docker.io/istio/pilot:1.25.0 ${CONTAINER_REGISTRY}/pilot:1.25.0
docker push ${CONTAINER_REGISTRY}/pilot:1.25.0

docker pull --platform=linux/amd64 docker.io/istio/install-cni:1.25.0
docker tag docker.io/istio/install-cni:1.25.0 ${CONTAINER_REGISTRY}/install-cni:1.25.0
docker push ${CONTAINER_REGISTRY}/install-cni:1.25.0

# docker pull --platform=linux/amd64 docker.io/istio/examples-helloworld-v1:1.0
# docker tag docker.io/istio/examples-helloworld-v1:1.0 ${CONTAINER_REGISTRY}/examples-helloworld-v1:1.0
# docker push ${CONTAINER_REGISTRY}/examples-helloworld-v1:1.0

