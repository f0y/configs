! /bin/sh
### BEGIN INIT INFO
# Provides:          virtualbox-DevEnv
# Required-Start:    $local_fs $remote_fs vboxdrv vboxnet
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: DevEnv virtual machine
# Description:       DevEnv virtual machine hosted by VirtualBox
### END INIT INFO
 
# Author: Brendan Kidwell <brendan@glump.net>
#
# Based on /etc/init.d/skeleton from Ubuntu 8.04. Updated for Ubuntu 9.10.
# If you are using Ubuntu <9.10, you might need to change "Default-Stop"
# above to "S 0 1 6".
 
# Do NOT "set -e"
 
# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/usr/sbin:/usr/bin:/sbin:/bin
DESC="DevEnv virtual machine"
NAME=virtualbox-DevEnv
SCRIPTNAME=/etc/init.d/$NAME
VERBOSE=yes
 
MANAGE_CMD=VBoxManage
VM_OWNER=f0y
VM_NAME="DevEnv" #This has to be the name exactly as it appears in your VirtualBox GUI control panel.
 
# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME
 
# Load the VERBOSE setting and other rcS variables
[ -f /etc/default/rcS ] && . /etc/default/rcS
 
# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions
 
#
# Function that starts the daemon/service
#
do_start()
{
   # Return
   #   0 if daemon has been started
   #   1 if daemon was already running
   #   2 if daemon could not be started
 
   sudo -H -u $VM_OWNER $MANAGE_CMD showvminfo "$VM_NAME"|grep "^State:\s*running" >/dev/null && {
       echo "$VM_NAME" is already running.
       return 1
   }
 
   sudo -H -u $VM_OWNER $MANAGE_CMD startvm "$VM_NAME" -type vrdp >/dev/null || {
       echo Failed to start "$VM_NAME".
       return 2
   }
 
   echo "$VM_NAME" started or resumed.
   return 0
}
 
#
# Function that stops the daemon/service
#
do_stop()
{
   # Return
   #   0 if daemon has been stopped
   #   1 if daemon was already stopped
   #   2 if daemon could not be stopped
   #   other if a failure occurred
 
   sudo -H -u $VM_OWNER $MANAGE_CMD showvminfo "$VM_NAME"|grep "^State:\s*running" >/dev/null || {
       echo "$VM_NAME" is already stopped.
       return 1
   }
 
   sudo -H -u $VM_OWNER $MANAGE_CMD controlvm "$VM_NAME" savestate || {
       echo Failed to stop "$VM_NAME".
       return 2
   }
 
   echo "$VM_NAME" suspended.
   return 0
}
 
#
# Display "State" field from showinfo action
#
do_status()
{
   sudo -H -u $VM_OWNER $MANAGE_CMD showvminfo "$VM_NAME"|grep "^State:\s*.*$"
}
 
case "$1" in
  start)
   [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
   do_start
   case "$?" in
      0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
      2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
   esac
   ;;
  stop)
   [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
   do_stop
   case "$?" in
      0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
      2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
   esac
   ;;
  restart|force-reload)
   #
   # If the "reload" option is implemented then remove the
   # 'force-reload' alias
   #
   log_daemon_msg "Restarting $DESC" "$NAME"
   do_stop
   case "$?" in
     0|1)
      do_start
      case "$?" in
         0) log_end_msg 0 ;;
         1) log_end_msg 1 ;; # Old process is still running
         *) log_end_msg 1 ;; # Failed to start
      esac
      ;;
     *)
      # Failed to stop
      log_end_msg 1
      ;;
   esac
   ;;
  status)
   do_status
   ;;
  *)
   #echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
   echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload|status}" >&2
   exit 3
   ;;
esac