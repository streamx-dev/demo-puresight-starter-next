#!/bin/bash

STREAMX_CLOUD_INFRA_PATH=$1
PROJECT=${2:-ds-puresight}

echo "Deploying to main cluster"
export QUARKUS_PROFILE=sxcloud
export KUBECONFIG="$STREAMX_CLOUD_INFRA_PATH/clusters/pilot/streamx-cloud-pilot_kubeconfig.yaml"
streamx deploy -n "$PROJECT" -f mesh/mesh.yaml
echo "Deployment to main cluster complete."

