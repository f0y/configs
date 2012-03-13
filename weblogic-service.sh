#!/bin/sh
#
# weblogic start and shutdown
#
# Copyright (c) Shoppers Drug Mart 2005
#
# Bootup and shutdown script
#
# /etc/init.d/weblogic
#
### BEGIN INIT INFO
# Provides:       weblogic
# Required-Start: $network $syslog
# Required-Stop:
# Default-Start:  2  3 4 5
# Default-Stop: 0 1 6
# Description:    Start weblogic a3 domain server
### END INIT INFO

A3DOMAIN_HOME=/opt/Oracle/Middleware/user_projects/domains/a3tv-dev/

case $1 in
'start')
        echo "Starting weblogic..."
        su user -c "cd ${A3DOMAIN_HOME}; ./startWebLogic.sh  > ${A3DOMAIN_HOME}/logs/boot.log 2>&1" &
    ;;
'stop')
        echo "Stopping weblogic..."
        su user -c "cd ${A3DOMAIN_HOME}/bin; ./stopWebLogic.sh > ${A3DOMAIN_HOME}/logs/stop.log 2>&1"
    ;;
*)
        echo "Usage: $0 {start|stop}"
    ;;
esac