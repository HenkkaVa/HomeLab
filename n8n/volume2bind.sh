#!/bin/bash

# Set paths - you need to change this as per your setup
DATA_DIR="/home/henri/self-hosting/n8n/n8n_data"

VOLUME_NAME="temp_n8n"

# Step 1: Create and start a temporary container to populate named volume
docker run --rm \
  --name temp-n8n-init \
  -v ${VOLUME_NAME}:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n:latest true

# Step 2: Copy from named volume to bind mount
docker run --rm \
  -v ${VOLUME_NAME}:/from \
  -v ${DATA_DIR}:/to \
  alpine sh -c "cp -r /from/. /to/"

# Step 3: Fix ownership and permissions
sudo chown -R 1000:1000 "${DATA_DIR}"
sudo chmod 600 "${DATA_DIR}/config"

# Step 4: Show success
echo "n8n_data folder is ready with correct contents and permissions."
