#! /bin/bash

dns=dns
for opt in ${!foreign_option_*}
do
   eval "dns=\${$opt#dhcp-option DNS }"
   if [ "$dns" != "dns" ]
       then
          echo ";; created by openvpn --up ${0} " >/tmp/resolv.conf
          grep search /etc/resolv.conf >>/tmp/resolv.conf
          echo "nameserver $dns" >>/tmp/resolv.conf
          if [[ ! -e resolv.conf ]]
          then
                mv /etc/resolv.conf ./resolv.conf
          fi
          mv -f /tmp/resolv.conf /etc 
          exit 0
       fi
done
