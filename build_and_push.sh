#!/bin/bash
# Run this once: docker buildx create --use --name build --node build --driver-opt network=host
PIHOLE_VER=`cat VERSION`
docker buildx build --build-arg PIHOLE_VERSION=$PIHOLE_VER --platform linux/amd64 -t biomann/docker-pihole-unbound:$PIHOLE_VER --push .
docker buildx build --build-arg PIHOLE_VERSION=$PIHOLE_VER --platform linux/amd64 -t biomann/docker-pihole-unbound:latest --push .
