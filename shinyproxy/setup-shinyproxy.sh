#!/bin/sh

# Download Docker images to be run in ShinyProxy
SHINYPROXY_DIR=$(dirname "$0")
SHINYPROXY_CONFIG="${SHINYPROXY_DIR}/application.yml"

echo "Downloading Docker images in ${SHINYPROXY_CONFIG}..."
imgs=$(sed -ne 's/^.*container-image: //p' ${SHINYPROXY_CONFIG})

for i in ${imgs}; do
    echo "----> ${i}"
    docker pull ${i}
    echo
done
