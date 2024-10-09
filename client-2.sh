#!/bin/bash

# Download the lubuntu-setup.sh script from the specified URL
wget http://10.2.2.254/static/docs/latest/lubuntu-setup.sh

# Run the downloaded script with sudo
if [[ -f "lubuntu-setup.sh" ]]; then
   bash lubuntu-setup.sh
else
  echo "Failed to download lubuntu-setup.sh."
fi

# Define the entries to be added
HOSTS_ENTRIES="
10.2.2.105      emr.fortiseahk.com
10.2.2.104      fad.emr.fortiseahk.com
10.2.2.105      fwb.emr.fortiseahk.com
10.2.2.106      fwb-ml.fortinet.demo
10.2.2.107      fad-al.fortinet.demo
10.2.2.108      fwb-api.fortinet.demo
10.2.2.109      fad-api.fortinet.demo
10.2.2.110      fwb-test.fortinet.demo
10.2.2.111      fad-test.fortinet.demo
"

# Backup the original /etc/hosts
cp /etc/hosts /etc/hosts.backup
cp ~/partner-lab/client_script ~/Desktop/
# Append the new entries
echo "$HOSTS_ENTRIES" >> /etc/hosts

echo "Entries added to /etc/hosts successfully."

# Install some additional packages                                                                                                                                                             
echo " *** You may continue while packages are installed ***"                                                                                                                                  
startmsg "Installing additional packages"                                                                                                                                                      
#skipping apt update to avoid killing lubuntu with python3-pip install                                                                                                                         
#sudo apt update > /dev/null 2>&1                                                                                                                                                              
sudo apt install -y -qq curl ssh python3-pip> /dev/null 2>&1                                                                                                                                   
endmsg                                                                                                                                                                                         
                                                                                                                                                                                               
# Making space on / partition                                                                                                                                                                  
startmsg "Cleaning root partition space"                                                                                                                                                       
sudo rm /var/cache/apt/archive/*.deb > /dev/null 2>&1                                                                                                                                          
endmsg                  

# Installing Selenium environment                                                                                                                                                              
startmsg "Preparing Selenium environment"                                                                                                                                                      
cd ${LUBUNTUHOME}/Downloads                                                                                                                                                                    
wget --quiet https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > /dev/null 2>&1                                                                                        
sudo dpkg -i google-chrome-stable_current_amd64.deb > /dev/null 2>&1                                                                                                                           
pip3 install selenium --quiet > /dev/null 2>&1                                                                                                                                                 
pip3 install webdriver-manager --quiet > /dev/null 2>&1                                                                                                                                        
endmsg