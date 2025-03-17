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

docker pull --platform=linux/amd64 europe-west1-docker.pkg.dev/streamx-releases/streamx-docker-releases/streamx-operator/streamx-operator:0.0.12-jvm
docker tag europe-west1-docker.pkg.dev/streamx-releases/streamx-docker-releases/streamx-operator/streamx-operator:0.0.12-jvm ${CONTAINER_REGISTRY}/streamx-operator:0.0.12-jvm
docker push ${CONTAINER_REGISTRY}/streamx-operator:0.0.12-jvm

docker pull --platform=linux/amd64 ghcr.io/streamx-dev/streamx/pulsar-init:latest-jvm
docker tag ghcr.io/streamx-dev/streamx/pulsar-init:latest-jvm ${CONTAINER_REGISTRY}/pulsar-init:latest-jvm
docker push ${CONTAINER_REGISTRY}/pulsar-init:latest-jvm

docker pull --platform=linux/amd64 ghcr.io/streamx-dev/streamx-blueprints/web-delivery-service:2.0.0-jvm
docker tag ghcr.io/streamx-dev/streamx-blueprints/web-delivery-service:2.0.0-jvm ${CONTAINER_REGISTRY}/web-delivery-service:2.0.0-jvm
docker push ${CONTAINER_REGISTRY}/web-delivery-service:2.0.0-jvm

docker pull --platform=linux/amd64 ghcr.io/streamx-dev/streamx-blueprints/opensearch-delivery-service:2.0.0-jvm
docker tag ghcr.io/streamx-dev/streamx-blueprints/opensearch-delivery-service:2.0.0-jvm ${CONTAINER_REGISTRY}/opensearch-delivery-service:2.0.0-jvm
docker push ${CONTAINER_REGISTRY}/opensearch-delivery-service:2.0.0-jvm

docker pull --platform=linux/amd64 docker.io/library/nginx:1.26.0
docker tag docker.io/library/nginx:1.26.0 ${CONTAINER_REGISTRY}/nginx:1.26.0
docker push ${CONTAINER_REGISTRY}/nginx:1.26.0

docker pull --platform=linux/amd64 docker.io/opensearchproject/opensearch:2.16.0
docker tag docker.io/opensearchproject/opensearch:2.16.0 ${CONTAINER_REGISTRY}/opensearch:2.16.0
docker push ${CONTAINER_REGISTRY}/opensearch:2.16.0
