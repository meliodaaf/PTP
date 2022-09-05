#!/bin/bash

IP=$1
MASK=$2

function find_alive_hosts {
# Ping sweep
    fping -a -g $IP/$MASK 2>/dev/null | tee OUTPUTS/$IP-ALIVE-HOSTS
}

function no_ping {
    nmap -n -sn -PS22,135,443,445 $IP/$MASK -oG OUTPUTS/$IP-NO-PING-SCAN
    cat OUTPUTS/$IP-NO-PING-SCAN | grep up | awk ' {print $2 } ' > OUTPUTS/$IP-ALL-HOSTS
}

function dns_discovery {
# Find IPs with port 53 open
    nmap -sS -sU -p53 -n $IP/$MASK -oG OUTPUTS/$IP-NMAP-DNS
    cat OUTPUTS/$IP-NMAP-DNS | grep open | awk ' {print $2} ' > OUTPUTS/$IP-DNS-SERVERS
}

function nmap_scan {
# NMAP Scan each IP grom output.txt

for host in $(cat OUTPUTS/$IP-ALIVE-HOSTS)
do
    nmap -A -T4 $host -oN OUTPUTS/$host-ALL-HOSTS
done

}


if [ -z $1 ]; then
    echo "Usage: sudo host-discovery.sh 10.10.10.0 24"
else
    echo "[*] Scanning $IP/$MASK"
    echo "========================================================"
    find_alive_hosts
    echo "========================================================"
    dns_discovery
    echo "========================================================"
    nmap_scan
    eecho "========================================================"
fi
