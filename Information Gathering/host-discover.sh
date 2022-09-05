#!/bin/bash

IP=$1
MASK=$2

function find_alive_hosts {
# Ping sweep
    fping -a -g $IP/$MASK 2>/dev/null | tee OUTPUTS/$IP-ALIVE-HOSTS
}

function no_ping {
    # Scan network without ping
    nmap -n -sn -PS22,135,443,445 $IP/$MASK -oG OUTPUTS/$IP-NO-PING-SCAN
    cat OUTPUTS/$IP-NO-PING-SCAN | grep Up | awk ' {print $2 } ' >> OUTPUTS/$IP-ALIVE-HOSTS
}

function dns_discovery {
# Find IPs with port 53 open
    nmap -sS -sU -p53 -n $IP/$MASK -oG OUTPUTS/$IP-NMAP-DNS
    echo -e "\n[*] Host with Port 53 open\n"
    cat OUTPUTS/$IP-NMAP-DNS | grep open | awk ' {print $2} ' | tee OUTPUTS/$IP-DNS-SERVERS
}

function nmap_scan {
# NMAP Scan each IP grom output.txt
echo -e "[*] Scanning IPs:\n"

cat OUTPUTS/$IP-ALIVE-HOSTS | sort | uniq > OUTPUTS/ALL-HOSTS

for host in $(cat OUTPUTS/ALL-HOSTS)
do
    nmap -A -T4 $host -oN OUTPUTS/$host-INTENSE-SCAN
done

}


if [ -z $1 ]; then
    echo "Usage: sudo host-discovery.sh 10.10.10.0 24"
else
    echo -e "[*] Scanning $IP/$MASK\n"
    echo -e "\n===================SWEEP-SCAN===========================\n"
    find_alive_hosts
    echo -e "\n================SWEEP-SCAN-NO-PING=======================\n"
    no_ping
    echo -e "\n=============FINDING HOST WITH PORT 53 OPEN=============\n"
    dns_discovery
    echo -e "\n==================NMAP INTENSE SCAN=====================\n"
    nmap_scan
fi
