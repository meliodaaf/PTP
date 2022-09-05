#!/bin/bash

IP=$1
MASK=$2

if [ -z $2 ]; then
MASK=32
fi

echo Scanning $IP/$MASK
function find_alive_hosts {
# Ping sweep

    fping -a -g $IP/$MASK | tee OUTPUTS/alive-hosts.txt
}

function dns_discovery {
    nmap -sS -sU -p53 -n $IP/$MASK | tee OUTPUTS/dns-servers.txt
}

function nmap_scan {
# NMAP Scan each IP grom output.txt

for i in $(cat OUTPUTS/alive-hosts.txt)
do
    nmap -sS $i -oN OUTPUTS/$i-scan
done

}


find_alive_hosts
dns_discovery
