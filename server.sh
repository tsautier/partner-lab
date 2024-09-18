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

# Bring up Finance Web for ML use-case
docker run -d -p 8004:80 -v /root/partner-lab/fweb-ml-test:/usr/local/apache2/htdocs/  httpd
docker run -d -p 8006:8088 teguhasiong/api4fun
docker run -d -p 8007:8080 fortinetdemo/petstore
docker run -d -p 8008:80 fortinetdemo/bwapp
docker run -d -p 8010:80 ibsina/test1-page
docker run -d -p 8011:80 ibsina/test2-page
docker run -d -p 8012:80 ibsina/test3-page