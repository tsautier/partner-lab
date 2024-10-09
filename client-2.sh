#!/bin/bash

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