#!/bin/sh

# Download Docker images to be run in ShinyProxy
dir=$(dirname "$0")
file="${dir}/application.yml"

echo "Downloading Docker images in ${file}..."
imgs=$(sed -ne 's/^.*container-image: //p' ${file})

for i in ${imgs}; do
    echo "----> ${i}"
    docker pull ${i}
    echo
done
