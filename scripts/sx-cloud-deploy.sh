#!/bin/bash

STREAMX_CLOUD_INFRA_PATH=$1
PROJECT=${2:-ds-puresight}

echo "Deploying to main cluster"
export QUARKUS_PROFILE=sxcloud
export KUBECONFIG="$STREAMX_CLOUD_INFRA_PATH/clusters/pilot/streamx-cloud-pilot_kubeconfig.yaml"
streamx deploy -n "$PROJECT" -f mesh/mesh.yaml
echo "Deployment to main cluster complete."


# List of edge regions (TODO)
EDGE_REGIONS=()

export QUARKUS_PROFILE=sxcloud-edge

for EDGE_REGION in "${EDGE_REGIONS[@]}"; do
  echo "Deploying to region: $EDGE_REGION"
  EDGE_REGION_SUBDOMAIN="${EDGE_REGION//_/-}"
  export EDGE_REGION_SUBDOMAIN
  export KUBECONFIG="$STREAMX_CLOUD_INFRA_PATH/environments/prod/piglets/.env/${EDGE_REGION}_kubeconfig.yaml"

  # Ensure namespace exists
  kubectl get namespace "$PROJECT" >/dev/null 2>&1 || kubectl create namespace "$PROJECT"

  # Deploy StreamX mesh
  streamx deploy -n "$PROJECT" -f mesh/mesh.yaml

  echo "Deployment to $EDGE_REGION complete."
done
