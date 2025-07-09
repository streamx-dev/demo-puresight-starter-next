#!/bin/bash

STREAMX_CLOUD_INFRA_PATH=$1
PROJECT=${2:-ds-www-streamx-dev}
export QUARKUS_PROFILE=sxcloud-edge

EDGE_REGION="alicloud_beijing"
echo "Deploying to region: $EDGE_REGION"
EDGE_REGION_SUBDOMAIN="${EDGE_REGION//_/-}"
export EDGE_REGION_SUBDOMAIN
export KUBECONFIG="$STREAMX_CLOUD_INFRA_PATH/environments/prod/piglets/.env/${EDGE_REGION}_kubeconfig.yaml"

# Ensure namespace exists
kubectl get namespace "$PROJECT" >/dev/null 2>&1 || kubectl create namespace "$PROJECT"
kubectl label namespace "$PROJECT" istio-injection=enabled --overwrite

# Deploy StreamX mesh
streamx deploy -n "$PROJECT" -f mesh/mesh.yaml

echo "Deployment to $EDGE_REGION complete."

