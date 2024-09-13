#! /bin/bash

## preparing machine and installing microk8
## version 1.1
# M. Duijm - Fortinet CSE
                                                                                                                                                                                             
  
#Setting up variables
FORTIPOC=$(/sbin/ip route | awk '/default/ { print $3 }')
FOLDER="/static/docs/latest/config"
JSON="docker_registry_config.json"
LOGFILE=/tmp/lubuntu-setup-$$.log
                                                                                                                                                                                             
  
                                                                                                                                                                                             
  
# Checking as this script must be run as root:
#   $ sudo ./microk8-prepare.sh
clear
                                                                                                                                                                                             
  
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" 1>&2
        exit 1
fi
                                                                                                                                                                                             
  
# scripting timing
start=$SECONDS
                                                                                                                                                                                             
  
echo -e "\n===========================\n MicroK8 Environment preparing \n==========================="
sleep 2
                                                                                                                                                                                             
  
# set hostname
hostnamectl set-hostname 'ingress'
                                                                                                                                                                                             
  
echo -e "\n===========================\n Installing MicroK8/Curl and Helm \n==========================="
# installing Microk8, Curl and Helm
snap install microk8s --classic --channel=1.28/stable
                                                                                                                                                                                             
  
#Remove group-readable
#chmod 600 /var/snap/microk8s/2948/credentials/client.config
  
#Allowing user fortinet to manage microk8
usermod -a -G microk8s fortinet
chown -f -R fortinet ~/.kube
                                                                                                                                                                                             
  
#enable services
microk8s enable dns                                                                                                                                                                          
  
microk8s enable helm3                                                                                                                                                                        
  
                                                                                                                                                                                             
  
#update firewall
ufw allow in on cni0 && ufw allow out on cni0
ufw default allow routed                                                                                                                                                                     
                                                                                                                                                                                             
cd /home/fortinet
                                                                                                                                                                                             
  
#Add fortinet repo
#microk8s helm3 repo add fortiadc-ingress-controller https://fortinet.github.io/fortiadc-ingress/                                                                                             
microk8s helm3 repo add FortiWeb-ingress-controller https://fortinet.github.io/fortiweb-ingress/

#microk8s helm3 repo add fortiadc-ingress-controller https://github.com/fortinet/fortiadc-ingress
microk8s helm3 repo update                                                                                                                                                                   

#Create Namespace
microk8s kubectl create namespace fortifwb-ingress                                                                                                                                                                                                                                                                                                                                      
  
# Install fortiadc ingress controller into namespace created above
microk8s helm3 install ingress-controller --namespace fortifwb-ingress FortiWeb-ingress-controller/fwb-k8s-ctrl
                                                                                                                                                                                             
  
# Install demo application hello-minikube to have some example webserver.
microk8s kubectl apply -f https://raw.githubusercontent.com/mduijm/fortidemo/main/hello-minikube.yaml
                                                                                                                                                                                             
  
# add kubectl alias
echo "alias kc='microk8s kubectl'" >> /home/fortinet/.bashrc
source ~/.bashrc
                                                                                                                                                                                             
  
# Added to show how long the script ran
duration=$(( SECONDS - start ))
echo 'it took: '$duration 'seconds to run this script'
                                                                                                                                                                                             
  
# Last manual steps
echo -e "\n\n Microk8 installation is done \n\n\033[1;32mPlease logout and login again to update the some settings and permissions \033[0m"
