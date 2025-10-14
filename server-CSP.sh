#!/bin/bash

# Update package lists
#apt update
sudo apt update && sudo apt upgrade -y

# 3. Install required dependencies
sudo apt install ca-certificates curl gnupg lsb-release -y

# 4. Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 5. Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 6. Update package list again
sudo apt update

# 7. Install Docker Engine, CLI, containerd and plugins
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# 8. Enable and start the Docker service
sudo systemctl enable docker
sudo systemctl start docker

# 9. Verify installation
docker --version
docker compose version

# 10. (Optional) Run Docker without sudo
sudo usermod -aG docker $USER
newgrp docker

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
