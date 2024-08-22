#!/bin/bash
set -euo pipefail

# Ensure Docker Buildx is installed
if ! command -v docker buildx &> /dev/null; then
    echo "Docker Buildx is not installed. Please install it and try again."
    exit 1
fi

# Set up Docker Buildx builder if not already created
if ! docker buildx inspect build &> /dev/null; then
    echo "Creating Docker Buildx builder..."
    docker buildx create --use --name build --node build --driver-opt network=host
fi

# Ensure GITHUB_USERNAME is set, or use the GitHub actor (the user who triggered the workflow) as a default
GITHUB_USERNAME=${GITHUB_USERNAME:-${GITHUB_ACTOR:-}}

if [ -z "$GITHUB_USERNAME" ]; then
    echo "GITHUB_USERNAME is not set. Please set it as an environment variable."
    exit 1
fi

# Get the Pi-hole version from the VERSION file, or use the environment variable if set
PIHOLE_VER=${PIHOLE_VERSION:-$(cat ./pihole-unbound/VERSION)}

# Define platforms to target
PLATFORMS="linux/arm/v7,linux/arm64/v8,linux/amd64"

# Define image name for GitHub Container Registry
IMAGE_NAME="ghcr.io/${GITHUB_USERNAME}/pihole-unbound"

# Log in to GitHub Container Registry (GHCR)
echo "${GITHUB_TOKEN}" | docker login ghcr.io -u "${GITHUB_USERNAME}" --password-stdin

# Build and push the version-specific image to GHCR
echo "Building and pushing image with tag: $PIHOLE_VER to GHCR"
docker buildx build \
    --build-arg PIHOLE_VERSION="$PIHOLE_VER" \
    --platform "$PLATFORMS" \
    -t "$IMAGE_NAME:$PIHOLE_VER" \
    -f ./pihole-unbound/Dockerfile \
    ./pihole-unbound \
    --push

# Build and push the 'latest' tagged image to GHCR
echo "Building and pushing image with tag: latest to GHCR"
docker buildx build \
    --build-arg PIHOLE_VERSION="$PIHOLE_VER" \
    --platform "$PLATFORMS" \
    -t "$IMAGE_NAME:latest" \
    -f ./pihole-unbound/Dockerfile \
    ./pihole-unbound \
    --push

echo "Docker images successfully built and pushed to GHCR."
