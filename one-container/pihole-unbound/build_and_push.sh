#!/bin/bash
# Run this once: docker buildx create --use --name build --node build --driver-opt network=host
docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 -t cbcrowe/pihole-unbound:`cat VERSION` --push .
docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 -t cbcrowe/pihole-unbound:latest --push .


