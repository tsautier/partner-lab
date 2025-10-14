#!/bin/bash

# Update package lists
#apt update
apt update && apt clean && rm -rf /var/lib/apt/lists/*

# Download Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make Docker Compose executable
chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
#docker-compose --version

# Bring up the Docker Compose services in detached mode
#docker-compose up -d

# Bring up Finance Web for ML use-case
docker run -d -p 8004:80 -v /root/partner-lab/fweb-ml-test:/usr/local/apache2/htdocs/  httpd:alpine
docker run -d -p 8010:80 -v /root/partner-lab/test1:/usr/local/apache2/htdocs/ httpd:alpine 
docker run -d -p 8011:80 -v /root/partner-lab/test2:/usr/local/apache2/htdocs/ httpd:alpine 
docker run -d -p 8012:80 -v /root/partner-lab/test3:/usr/local/apache2/htdocs/ httpd:alpine 
docker run -d -p 8006:8088 teguhasiong/api4fun
