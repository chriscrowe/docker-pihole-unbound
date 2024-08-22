#!/bin/bash
set -euo pipefail

# Check if Docker Buildx is installed
if ! command -v docker buildx &> /dev/null; then
    echo "Docker Buildx is not installed. Please install it and try again."
    exit 1
fi

# Set up Docker Buildx builder if not already created
if ! docker buildx inspect build &> /dev/null; then
    echo "Creating Docker Buildx builder..."
    docker buildx create --use --name build --node build --driver-opt network=host
fi

# Get the Pi-hole version from the VERSION file, or use environment variable if set
PIHOLE_VER=${PIHOLE_VERSION:-$(cat ./pihole-unbound/VERSION)}

# Define platforms to target
PLATFORMS="linux/arm/v7,linux/arm64/v8,linux/amd64"

# Define image name
IMAGE_NAME="bioszombie/pihole-unbound"

# Build and push the version-specific image
echo "Building and pushing image with tag: $PIHOLE_VER"
docker buildx build \
    --build-arg PIHOLE_VERSION=$PIHOLE_VER \
    --platform $PLATFORMS \
    -t $IMAGE_NAME:$PIHOLE_VER \
    --push .

# Build and push the 'latest' tagged image
echo "Building and pushing image with tag: latest"
docker buildx build \
    --build-arg PIHOLE_VERSION=$PIHOLE_VER \
    --platform $PLATFORMS \
    -t $IMAGE_NAME:latest \
    --push .

echo "Docker images successfully built and pushed."
