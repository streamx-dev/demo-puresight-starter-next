CONTAINER_REGISTRY=crpi-ynub1f3ynqwgpy46.cn-hangzhou.personal.cr.aliyuncs.com/streamx-demo

docker pull --platform=linux/amd64 apache/apisix:3.11.0-debian
docker tag apache/apisix:3.11.0-debian ${CONTAINER_REGISTRY}/apisix:3.11.0-debian
docker push ${CONTAINER_REGISTRY}/apisix:3.11.0-debian

docker pull --platform=linux/amd64 apache/apisix-ingress-controller:1.8.0
docker tag apache/apisix-ingress-controller:1.8.0 ${CONTAINER_REGISTRY}/apisix-ingress-controller:1.8.0
docker push ${CONTAINER_REGISTRY}/apisix-ingress-controller:1.8.0


docker pull --platform=linux/amd64 docker.io/bitnami/etcd:3.5.10-debian-11-r2
docker tag docker.io/bitnami/etcd:3.5.10-debian-11-r2 ${CONTAINER_REGISTRY}/etcd:3.5.10-debian-11-r2
docker push ${CONTAINER_REGISTRY}/etcd:3.5.10-debian-11-r2

docker pull --platform=linux/amd64 docker.io/library/busybox:1.28
docker tag docker.io/library/busybox:1.28 ${CONTAINER_REGISTRY}/busybox:1.28
docker push ${CONTAINER_REGISTRY}/busybox:1.28