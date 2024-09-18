#!/bin/bash

# Define the entries to be added
HOSTS_ENTRIES="
10.2.2.104      emr.fortiseahk.com
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

# Append the new entries
echo "$HOSTS_ENTRIES" >> /etc/hosts

echo "Entries added to /etc/hosts successfully."
