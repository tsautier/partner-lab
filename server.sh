#!/bin/bash

# Update package lists
apt update

# Download Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make Docker Compose executable
chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
docker-compose --version

# Bring up the Docker Compose services in detached mode
docker-compose up -d
