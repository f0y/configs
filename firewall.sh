#!/bin/sh


INET_IP="109.198.191.44"
INET_IFACE="ppp0"
INET_BROADCAST=""
LAN_IP="192.168.0.1"
LAN_IP_RANGE="192.168.0.0/24"
LAN_IFACE="eth1"
LO_IFACE="lo"
LO_IP="127.0.0.1"
IPTABLES="/sbin/iptables"
LANTT_IP="10.32.208.7"
LANTT_IFACE="eth0"
LANTT_BROADCAST="10.32.255.255"
LANTT_IP_RANGE="10.0.0.0/8"
/sbin/depmod -a
/sbin/modprobe ip_tables
/sbin/modprobe ip_conntrack
/sbin/modprobe iptable_filter
/sbin/modprobe iptable_mangle
/sbin/modprobe iptable_nat
/sbin/modprobe ipt_LOG
/sbin/modprobe ipt_limit
/sbin/modprobe ipt_state
# 2.2 Non-Required modules
/sbin/modprobe ipt_owner
/sbin/modprobe ipt_REJECT
/sbin/modprobe ipt_MASQUERADE
/sbin/modprobe ip_conntrack_ftp
/sbin/modprobe ip_conntrack_irc
/sbin/modprobe ip_nat_ftp
/sbin/modprobe ip_nat_irc
#FIXME Must be in the end
sysctl -w net.ipv4.ip_forward="1"
# 3.2 Non-Required proc configuration
#echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter
#echo "1" > /proc/sys/net/ipv4/conf/all/proxy_arp
sysctl -w net.ipv4.ip_dynaddr="1"

$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP

$IPTABLES -N bad_tcp_packets

$IPTABLES -N allowed
$IPTABLES -N tcp_packets
$IPTABLES -N udp_packets
$IPTABLES -N icmp_packets

# bad_tcp_packets chain
## nmap -sS (Scan: SYN+ACK = no defense... )
## nmap -sX (Scan: SYN+ACK+FIN+RST [+PSH+URG] = not implemented in TCP)
$IPTABLES -t filter -A bad_tcp_packets -p tcp -m state ! --state ESTABLISHED \
    --tcp-flags SYN,ACK,FIN,RST ALL  \
    -j LOG --log-level DEBUG --log-prefix "IPT TCP Scan: S+A+F+R: "

$IPTABLES -t filter -A bad_tcp_packets -p tcp -m state ! --state ESTABLISHED \
    --tcp-flags SYN,ACK,FIN,RST ALL  \
    -j REJECT --reject-with tcp-reset

## nmap -sN (Scan: none of any flags = not implemented in TCP)
$IPTABLES -t filter -A bad_tcp_packets -p tcp -m state ! --state ESTABLISHED \
    --tcp-flags SYN,ACK,FIN,RST NONE \
    -m limit --limit 10/minute --limit-burst 10 \
    -j LOG --log-level DEBUG --log-prefix "IPT TCP Scan: empty flags: "
$IPTABLES -t filter -A bad_tcp_packets -p tcp -m state ! --state ESTABLISHED \
    --tcp-flags SYN,ACK,FIN,RST NONE \
    -j REJECT --reject-with tcp-reset

## nmap -sF (Scan: only FIN)
$IPTABLES -t filter -A bad_tcp_packets -p tcp -m state ! --state ESTABLISHED \
    --tcp-flags SYN,ACK,FIN,RST FIN \
    -m limit --limit 10/minute --limit-burst 10 \
    -j LOG --log-level DEBUG --log-prefix "IPT TCP Scan: only FIN: "
$IPTABLES -t filter -A bad_tcp_packets -p tcp -m state ! --state ESTABLISHED \
    --tcp-flags SYN,ACK,FIN,RST FIN \
    -j REJECT --reject-with tcp-reset

## NEW, not SYN
#$IPTABLES -t filter -A bad_tcp_packets -p tcp --syn -m state ! --state NEW \
#    -m limit --limit 10/minute --limit-burst 10 \
#    -j LOG --log-level DEBUG --log-prefix "IPT TCP Scan: NEW not SYN: "
$IPTABLES -t filter -A bad_tcp_packets -p tcp --syn -m state ! --state NEW \
    -j REJECT --reject-with tcp-reset
#SIMPLE ANTI-SCAN
#$IPTABLES -A bad_tcp_packets -p tcp --tcp-flags SYN,ACK SYN,ACK \
#-m state --state NEW -j LOG --log-level DEBUG \
#--log-prefix "IPT BAD_TCP died:SCAN "
#$IPTABLES -A bad_tcp_packets -p tcp --tcp-flags SYN,ACK SYN,ACK \
#-m state --state NEW -j REJECT --reject-with tcp-reset 
#$IPTABLES -A bad_tcp_packets -p tcp ! --syn -m state --state NEW -j LOG \
#--log-level DEBUG --log-prefix "IPT BAD_TCP died:SCAN "
#$IPTABLES -A bad_tcp_packets -p tcp ! --syn -m state --state NEW -j REJECT \
#--reject-with tcp-reset

# allowed chain
$IPTABLES -A allowed -p TCP --syn -j ACCEPT
$IPTABLES -A allowed -p TCP -m state --state ESTABLISHED,RELATED -j ACCEPT
#$IPTABLES -A allowed -p TCP -j LOG --log-level DEBUG \
#--log-prefix "IPT ALLOWED died:NOT MATCH "
$IPTABLES -A allowed -p TCP -j REJECT --reject-with tcp-reset

# TCP rules
$IPTABLES -A tcp_packets -p TCP -s 0/0 --dport 22 -m state --syn --state NEW \
-m limit --limit 1/minute --limit-burst 2 -j allowed
$IPTABLES -A tcp_packets -p TCP -s 0/0 --dport 22 -m state --syn --state NEW \
-j REJECT --reject-with tcp-reset
$IPTABLES -A tcp_packets -p TCP -s 0/0 --dport 6881 -j allowed

# UDP ports
$IPTABLES -A udp_packets -p UDP -s 0/0 --dport 6881 -j ACCEPT

# Block all broadcasts
#$IPTABLES -A udp_packets -p ALL -i $INET_IFACE -d 255.255.255.255 \
# -j LOG --log-level DEBUG --log-prefix "IPT UDP died:BCAST "
$IPTABLES -A udp_packets -p ALL -i $INET_IFACE -d 255.255.255.255 \
 -j DROP

#$IPTABLES -A udp_packets -p ALL -i $LANTT_IFACE -d 255.255.255.255 \
# -j LOG --log-level DEBUG --log-prefix "IPT UDP died:BCAST "
$IPTABLES -A udp_packets -p ALL -i $LANTT_IFACE -d 255.255.255.255 \
 -j DROP

# In Microsoft Networks you will be swamped by broadcasts. These lines 
# will prevent them from showing up in the logs.

#$IPTABLES -A udp_packets -p UDP -i $INET_IFACE -d $INET_BROADCAST \
#--dport 135:139 -j LOG --log-level DEBUG --log-prefix "IPT UDP died:MS BCAST "
$IPTABLES -A udp_packets -p UDP -i $INET_IFACE -d $INET_BROADCAST \
--dport 135:139 -j DROP
#$IPTABLES -A udp_packets -p UDP -i $LANTT_IFACE -d $LANTT_BROADCAST \
#--dport 135:139 -j LOG --log-level DEBUG --log-prefix "IPT UDP died:MS BCAST "
$IPTABLES -A udp_packets -p UDP -i $LANTT_IFACE -d $LANTT_BROADCAST \
--dport 135:139 -j DROP

# If we get DHCP requests from the Outside of our network, our logs will 
# be swamped as well. This rule will block them from getting logged.
#$IPTABLES -A udp_packets -p UDP -i $INET_IFACE -d 255.255.255.255 \
#--dport 67:68 -j LOG --log-level DEBUG --log-prefix "IPT UDP died:DHCP "
$IPTABLES -A udp_packets -p UDP -i $INET_IFACE -d 255.255.255.255 \
--dport 67:68 -j DROP
#$IPTABLES -A udp_packets -p UDP -i $LANTT_IFACE -d 255.255.255.255 \
#--dport 67:68 -j LOG --log-level DEBUG --log-prefix "IPT UDP died:DHCP "
$IPTABLES -A udp_packets -p UDP -i $LANTT_IFACE -d 255.255.255.255 \
--dport 67:68 -j DROP

# ICMP rules
#$IPTABLES -A icmp_packets -p ICMP -s 0/0 --icmp-type echo-request -j ACCEPT
$IPTABLES -A icmp_packets -p ICMP -s 0/0 --icmp-type fragmentation-needed -j ACCEPT
$IPTABLES -A icmp_packets -p ICMP -s 0/0 --icmp-type time-exceeded -j ACCEPT

# Bad TCP packets we don't want.
$IPTABLES -A INPUT -p tcp -j bad_tcp_packets

# Rules for special networks not part of the Internet
$IPTABLES -A INPUT -p ALL -i $LAN_IFACE -s $LAN_IP_RANGE -j ACCEPT
$IPTABLES -A INPUT -p ALL -i $LO_IFACE -s $LO_IP -j ACCEPT
$IPTABLES -A INPUT -p ALL -i $LO_IFACE -s $LAN_IP -j ACCEPT
$IPTABLES -A INPUT -p ALL -i $LO_IFACE -s $INET_IP -j ACCEPT

# Special rule for DHCP requests from LAN, which are not caught properly
# otherwise.
$IPTABLES -A INPUT -p UDP -i $LAN_IFACE --dport 67 --sport 68 -j ACCEPT

# Rules for incoming packets from the internet.
$IPTABLES -A INPUT -p ALL -d $INET_IP -m state --state ESTABLISHED,RELATED \
-j ACCEPT
$IPTABLES -A INPUT -p ALL -d $LANTT_IP -m state --state ESTABLISHED,RELATED \
-j ACCEPT

$IPTABLES -A INPUT -p TCP -i $INET_IFACE -j tcp_packets
$IPTABLES -A INPUT -p UDP -i $INET_IFACE -j udp_packets
$IPTABLES -A INPUT -p ICMP -i $INET_IFACE -j icmp_packets

$IPTABLES -A INPUT -p TCP -i $LANTT_IFACE -j tcp_packets
$IPTABLES -A INPUT -p UDP -i $LANTT_IFACE -j udp_packets
$IPTABLES -A INPUT -p ICMP -i $LANTT_IFACE -j icmp_packets

# If you have a Microsoft Network on the outside of your firewall, you may 
# also get flooded by Multicasts. We drop them so we do not get flooded by 
# logs
#$IPTABLES -A INPUT -i $INET_IFACE -d 224.0.0.0/8 -j LOG --log-level DEBUG \
#--log-prefix "IPT INPUT died:MCAST "
$IPTABLES -A INPUT -i $INET_IFACE -d 224.0.0.0/8 -j DROP
#$IPTABLES -A INPUT -i $LANTT_IFACE -d 224.0.0.0/8 -j LOG --log-level DEBUG \
#--log-prefix "IPT INPUT died:MCAST "
$IPTABLES -A INPUT -i $LANTT_IFACE -d 224.0.0.0/8 -j DROP

# Log weird packets that don't match the above.
#$IPTABLES -A INPUT -j LOG \
#--log-level DEBUG --log-prefix "IPT INPUT died:NOT MATCH "

# Bad TCP packets we don't want
$IPTABLES -A FORWARD -p tcp -j bad_tcp_packets

# Accept the packets we actually want to forward
$IPTABLES -A FORWARD -i $LAN_IFACE -j ACCEPT
$IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Log weird packets that don't match the above.
$IPTABLES -A FORWARD -j LOG \
--log-level DEBUG --log-prefix "IPT FORWARD died: NOT MATCH"

# for compatibility with nmap
$IPTABLES -A OUTPUT -p tcp -j ACCEPT

# Special OUTPUT rules to decide which IP's to allow.
$IPTABLES -A OUTPUT -p ALL -s $LO_IP -j ACCEPT
$IPTABLES -A OUTPUT -p ALL -s $LAN_IP -j ACCEPT
$IPTABLES -A OUTPUT -p ALL -s $LANTT_IP -j ACCEPT
$IPTABLES -A OUTPUT -p ALL -s $INET_IP -j ACCEPT

# Log weird packets that don't match the above.
#$IPTABLES -A OUTPUT -j LOG --log-level DEBUG \
#--log-prefix "IPT OUTPUT died:NOT MATCH "
