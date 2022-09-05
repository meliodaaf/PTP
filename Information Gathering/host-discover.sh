#!/bin/bash

IP=$1
MASK=$2

function find_alive_hosts {
# Ping sweep
    fping -a -g $IP/$MASK | tee OUTPUTS/$IP-alive-hosts.txt
}

function dns_discovery {
# Find IPs with port 53 open
    nmap -sS -sU -p53 -n $IP/$MASK -oG OUTPUTS/$IP-dns-servers
    cat OUTPUTS/$IP-dns-servers | grep open | awk ' {print $1} ' > $IP-DNS-Servers.txt
}

function nmap_scan {
# NMAP Scan each IP grom output.txt

for i in $(cat OUTPUTS/alive-hosts.txt)
do
    nmap -sS $i -oN OUTPUTS/$i-scan
done

}


if [ -z $1 ]; then
    echo "Usage: sudo host-discovery.sh 10.10.10.0 24"
else
    find_alive_hosts
    dns_discovery
fi
