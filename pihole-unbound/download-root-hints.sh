#!/bin/bash

# Define the URL for the root hints file
ROOT_HINTS_URL="https://www.internic.net/domain/named.cache"

# Define the path where the root hints file will be saved
ROOT_HINTS_PATH="/var/lib/unbound/root.hints"

# Download the root hints file using curl
curl -o "$ROOT_HINTS_PATH" "$ROOT_HINTS_URL"

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Root hints file downloaded successfully."
else
    echo "Failed to download root hints file." >&2
    exit 1
fi

# Ensure Unbound uses the downloaded root hints
sed -i 's|# root-hints:.*|root-hints: "'$ROOT_HINTS_PATH'"|' /etc/unbound/unbound.conf.d/pi-hole.conf