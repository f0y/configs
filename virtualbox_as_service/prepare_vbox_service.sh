#!/bin/sh -e

touch /etc/default/virtualbox
echo "SHUTDOWN_USERS=\"f0y root\" # space-delimited list of users who might have runnings vms" >> /etc/default/virtualbox
echo "SHUTDOWN=savestate # if any are found, suspend them to disk" >> /etc/default/virtualbox

# sudo touch /etc/init.d/virtualbox-DevEnv
# sudo chmod +x /etc/init.d/virtualbox-DevEnv


   
