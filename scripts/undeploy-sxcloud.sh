#!/bin/bash
set -euo pipefail

STREAMX_CLOUD_INFRA_PATH=${1:-}
PROJECT=${2:-ds-puresight-eb835}

if [[ -z "$STREAMX_CLOUD_INFRA_PATH" ]]; then
  echo "Error: STREAMX_CLOUD_INFRA_PATH not provided."
  echo "Usage: $0 <streamx-cloud-infra-path> [project-name]"
  exit 1
fi

KUBECONFIG_FILE="$STREAMX_CLOUD_INFRA_PATH/clusters/pilot/streamx-cloud-pilot_kubeconfig.yaml"

if [[ ! -f "$KUBECONFIG_FILE" ]]; then
  echo "Error: kubeconfig not found at $KUBECONFIG_FILE"
  exit 1
fi

echo "Undeploying from pilot cluster"
export QUARKUS_PROFILE=cloud
export KUBECONFIG="$KUBECONFIG_FILE"

streamx undeploy -n "$PROJECT"

echo "Undeployment from pilot cluster complete."
