#! /bin/bash                                                                                                                                                                                   
                                                                                                                                                                                               
FORTIPOCIP="10.2.2.254"                                                                                                                                                                        
FORTIPOCDIR="static/docs/latest"                                                                                                                                                               
LUBUNTUHOME="/home/lubuntu"                                                                                                                                                                    
                                                                                                                                                                                               
# Color code definitions                                                                                                                                                                       
BLACK='\033[0;30m'       ; DARKGRAY='\033[1;30m'                                                                                                                                               
RED='\033[0;31m'         ; LIGHTRED='\033[1;31m'                                                                                                                                               
GREEN='\033[0;32m'       ; LIGHTGREEN='\033[1;32m'                                                                                                                                             
ORANGE='\033[0;33m'      ; export YELLOW='\033[1;33m'                                                                                                                                          
BLUE='\033[0;34m'        ; LIGHTBLUE='\033[1;34m'                                                                                                                                              
PURPLE='\033[0;35m'      ; LIGHTPURPLE='\033[1;35m'                                                                                                                                            
CYAN='\033[0;36m'        ; LIGHTCYAN='\033[1;36m'                                                                                                                                              
LIGHTGRAY='\033[0;37m'   ; WHITE='\033[1;37m'                                                                                                                                                  
REDREVERSED='\033[0;41m' ; GREENREVERSED='\033[0;42m'                                                                                                                                          
REDREVERSEDNEW='\033[1;41m' ; GREENREVERSEDNEW='\033[1;42m'                                                                                                                                    
GREENNEW='\033[1;32m'                                                                                                                                                                          
NOCOLOR='\033[0m'                                                                                                                                                                              
                                                                                                                                                                                               
# functions                                                                                                                                                                                    
function startmsg {                                                                                                                                                                            
        echo -n " "$1"...."
}                                                                                                                                                                                              
                                                                                                                                                                                               
function endmsg {                                                                                                                                                                              
#       echo "${GREEN}done${NOCOLOR}"                                                                                                                                                          
        echo "done"                                                                                                                                                                            
}                                                                                                                                                                                              
                                                                                                                                                                                               
# variables                                                                                                                                                                                    
                                                                                                                                                                                               
# Populate hosts file so we can use FQDN's instead of IP-addresses                                                                                                                             
startmsg "Populating /etc/hosts file"                                                                                                                                                          
cat << EOF >> /etc/hosts                                                                                                                                                                       
10.2.2.101      dvwa.fortiworkshop.nl
10.2.2.102      juiceshop.fortiworkshop.nl
10.2.2.103      xxx.fortinet.demo
10.2.2.104      emr.fortiseahk.com
10.2.2.104      fad.emr.fortiseahk.com
10.2.2.105      fwb.emr.fortiseahk.com
10.2.2.106      fwb-ml.fortinet.demo
10.2.2.107      fad-al.fortinet.demo
10.2.2.108      fwb-api.fortinet.demo                                                                                                                                                          
10.2.2.109      fad-api.fortinet.demo                                                                                                                                                          
10.2.2.110      fwb-test.fortinet.demo                                                                                                                                                         
10.2.2.111      fad-test.fortinet.demo    
10.2.2.1        fad.fortinet.demo                                                                                                                                                              
10.2.2.2        fwb.fortinet.demo                                                                                                                                                              
10.2.2.3        fgt.fortinet.demo                                                                                                                                                              
EOF                                                                                                                                                                                            
endmsg                                                                                                                                                                                         
                                                                                                                                                                                               
# Check if Downloads directory exist                                                                                                                                                           
startmsg "Checking Downloads directory"                                                                                                                                                        
[ -d ${LUBUNTUHOME}/Downloads ] || mkdir ${LUBUNTUHOME}/Downloads                                                                                                                              
endmsg                                                                                                                                                                                         
                                                                                                                                                                                               
# Set Lubuntu password so you can SSH into Lubuntu                                                                                                                                             
startmsg "Setting lubuntu user pwd"                                                                                                                                                            
/usr/bin/passwd lubuntu << EOF > /tmp/passwd 2>&1
fortinet                                                                                                                                                                                       
fortinet                                                                                                                                                                                       
EOF                                                                                                                                                                                            
endmsg                                                                                                                                                                                         
                                                                                                                                                                                               
# Disabling X11 screensaver to reduce network load                                                                                                                                             
startmsg "Disabling screensaver"                                                                                                                                                               
sudo wget http://${FORTIPOCIP}/${FORTIPOCDIR}/config/xscreensaver -O ${LUBUNTUHOME}/.xscreensaver > /dev/null 2>&1                                                                             
endmsg                                                                                                                                                                                         
                                                                                                                                                                                               
# Install FortiDemo RootCA into Firefox                                                                                                                                                        
startmsg "Installing FortiDemo RootCA into Firefox"                                                                                                                                            
wget http://${FORTIPOCIP}/${FORTIPOCDIR}/config/rootca.fortinet.demo.crt -O /usr/local/share/ca-certificates/rootca.fortinet.demo.crt > /dev/null 2>&1                                         
                                                                                                                                                                                               
# Lubuntu prior to 22.04 (Jammy) works with filesystem for Firefox, not snapd packages                                                                                                         
if [ "$LUBUNTUVERSION" != "22.04" ]; then                                                                                                                                                      
    [ ! -d /usr/lib/firefox/distribution ] && mkdir -p /usr/lib/firefox/distribution                                                                                                           
    cat << EOF > /usr/lib/firefox/distribution/policies.json                                                                                                                                   
{                                                                                                                                                                                              
    "policies": {                                                                                                                                                                              
        "Certificates": {                                                                                                                                                                      
            "Install": [                                                                                                                                                                       
            "/usr/local/share/ca-certificates/rootca.fortinet.demo.crt"                                                                                                                        
            ]                                                                                                                                                                                  
        }                                                                                                                                                                                      
    }                                                                                                                                                                                          
}                                                                                                                                                                                              
EOF                                                                                                                                                                                            
fi                                                                                                                                                                                             
                                                                                                                                                                                               
# Lubuntu 22.04 (Jammy) works with snapd packages for Firefox. CA-root certificate loading changed.                                                                                            
if [ "$LUBUNTUVERSION" = "22.04" ]; then                                                                                                                                                       
    mkdir -p /etc/firefox/policies/ca-certificates                                                                                                                                             
    cat << EOF > /etc/firefox/policies/policies.json                                                                                                                                           
{                                                                                                                                                                                              
    "policies": {                                                                                                                                                                              
        "Certificates": {                                                                                                                                                                      
            "Install": [                                                                                                                                                                       
            "/etc/firefox/policies/ca-certificates/rootca.fortinet.demo.crt"                                                                                                                   
            ]                                                                                                                                                                                  
        }                                                                                                                                                                                      
    }                                                                                                                                                                                          
}                                                                                                                                                                                              
EOF                                                                                                                                                                                            
    # The certificate file needs to be in a /etc/firefox subdirectory, a symbolic link doesn't work.                                                                                           
    cp /usr/local/share/ca-certificates/rootca.fortinet.demo.crt /etc/firefox/policies/ca-certificates/rootca.fortinet.demo.crt                                                                
fi                                                                                                                                                                                             
endmsg                                                                                                                                                                                         
                                                                                                                                                                                               
# Adding FortiDemo RootCA to OpenSSL trusted certs                                                                                                                                             
startmsg "Adding FortiDemo RootCA to OpenSSL"                                                                                                                                                  
sudo update-ca-certificates > /dev/null 2>&1
endmsg                                                                                                                                                                                         
                                                                                                                                                                                               
                                                                                                                                                                                               
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
                                                                                                                                                                                               
# Populating Lubuntu-client with bot-test-scripts for good/bad BOT simulations                                                                                                                 
startmsg "Populating BOT testing scripts"                                                                                                                                                      
wget http://${FORTIPOCIP}/${FORTIPOCDIR}/bot-login-good.py -O ${LUBUNTUHOME}/bot-login-good.py > /dev/null 2>&1                                                                                
wget http://${FORTIPOCIP}/${FORTIPOCDIR}/bot-login-bad.py -O ${LUBUNTUHOME}/bot-login-bad.py > /dev/null 2>&1                                                                                  
wget http://${FORTIPOCIP}/${FORTIPOCDIR}/bot-login-infinite.sh -O ${LUBUNTUHOME}/bot-login-infinite.sh > /dev/null 2>&1                                                                        
wget http://${FORTIPOCIP}/${FORTIPOCDIR}/bot-juiceshop-bad.py -O ${LUBUNTUHOME}/bot-juiceshop-bad.py > /dev/null 2>&1                                                                          
wget http://${FORTIPOCIP}/${FORTIPOCDIR}/bot-juiceshop-good.py -O ${LUBUNTUHOME}/bot-juiceshop-good.py > /dev/null 2>&1                                                                        
chmod +x ${LUBUNTUHOME}/bot-login-infinite.sh > /dev/null 2>&1                                                                                                                                 
endmsg                                                                                                                                                                                         
                                                                                                                                                                                               
# Installing Selenium environment                                                                                                                                                              
startmsg "Preparing Selenium environment"                                                                                                                                                      
cd ${LUBUNTUHOME}/Downloads                                                                                                                                                                    
wget --quiet https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > /dev/null 2>&1                                                                                        
sudo dpkg -i google-chrome-stable_current_amd64.deb > /dev/null 2>&1                                                                                                                           
pip3 install selenium --quiet > /dev/null 2>&1                                                                                                                                                 
pip3 install webdriver-manager --quiet > /dev/null 2>&1                                                                                                                                        
endmsg
