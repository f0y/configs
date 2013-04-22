#!/bin/bash
#ip route add 0.0.0.0/0 dev ppp0 src 94.136.223.252 table 1
#ip route add 0.0.0.0/0 dev ppp1 src 109.198.191.12 table 2
#ip route add default via 10.32.208.7
ip rule add from 94.136.223.252 table 1
ip rule add from 109.198.191.33 table 2
ip route add default scope global nexthop  dev ppp0 weight 1 \
    nexthop dev ppp1 weight 1
