#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/ingestion/read-env.sh"

# Function to clean up nginx-proxy container
cleanup() {
  echo "Stopping and removing nginx-proxy container..."
  docker rm -f nginx-proxy >/dev/null 2>&1 || echo "nginx-proxy container is already stopped."
  exit 0
}

# Set up trap for CTRL+C
trap cleanup SIGINT

# Ensure previous nginx-proxy is removed
docker rm -f nginx-proxy >/dev/null 2>&1

# Print available URLs
echo "The following URLs are available:"
echo " - $WEB_URL"
echo " - http://ingestion.127.0.0.1.nip.io"

# Define script variables
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NGINX_CONF="${SCRIPT_DIR}/proxy.conf"

#Replace serverName
TEMP_CONF="${NGINX_CONF}.tmp"
sed "s|\$WEB_HOST|${WEB_HOST}|g" "$NGINX_CONF" > "$TEMP_CONF"

MESH_NETWORK=$(docker inspect rest-ingestion --format '{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}')

# Run nginx-proxy container
echo "Starting nginx-proxy container..."
docker run -d --rm --network "${MESH_NETWORK}" --name nginx-proxy -p 80:80 nginx:1.26.0

# Copy configuration and reload nginx
echo "Configuring nginx-proxy..."
docker cp "${TEMP_CONF}" nginx-proxy:/etc/nginx/nginx.conf
docker exec nginx-proxy nginx -s reload

#Cleanup
rm -f $TEMP_CONF

# Keep script running to handle CTRL+C
echo "nginx-proxy is running. Press CTRL+C to stop."
while true; do sleep 1; done