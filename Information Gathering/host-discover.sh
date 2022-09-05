#!/bin/bash

IP=$1
MASK=$2

function find_alive_hosts {
# Ping sweep
    fping -a -g $IP/$MASK 2>/dev/null | tee OUTPUTS/$IP-alive-hosts.txt
}

function dns_discovery {
# Find IPs with port 53 open
    nmap -sS -sU -p53 -n $IP/$MASK -oG OUTPUTS/$IP-NMAP-DNS
    cat OUTPUTS/$IP-dns-servers | grep open | awk ' {print $2} ' > OUTPUTS/$IP-DNS-Servers.txt
}

function nmap_scan {
# NMAP Scan each IP grom output.txt

for host in $(cat OUTPUTS/$IP-alive-hosts.txt)d
do
    nmap -sS $host -oN OUTPUTS/$host-scan
done

}


if [ -z $1 ]; then
    echo "Usage: sudo host-discovery.sh 10.10.10.0 24"
else
    echo "[*] Scanning $IP/$MASK"
    find_alive_hosts
    dns_discovery
    nmap_scan
fi
