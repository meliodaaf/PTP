#!/bin/bash

IP=$1
MASK=$2
DOMAIN=$3

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

function dns_enum {
    for server in $(cat OUTPUTS/$IP-DNS-SERVERS)
    do
        echo -e "\n[*] NS and MX Lookup:\n"
        nslookup -type=NS $DOMAIN $server | tee OUTPUTS/NS-MX
        nslookup -type=MX $DOMAIN $server | tee -a OUTPUTS/NS-MX

        echo -e "\n[*] Testing Zone Transfer using DIG:\n"
        dig @$server $DOMAIN -t AXFR +nocookie | tee OUTPUTS/ZONE-TRANSFER
        
        # echo -e "\n[*] Testing Zone Transfer using HOST:\n"
        # host -t axfr $DOMAIN $server
    done

}

function nmap_scan {
# NMAP Scan each IP grom output.txt
echo -e "[*] Scanning IPs:\n"

cat OUTPUTS/$IP-ALIVE-HOSTS | sort | uniq > OUTPUTS/ALL-HOSTS
echo -e "$(cat OUTPUTS/ALL-HOSTS)\n"
for host in $(cat OUTPUTS/ALL-HOSTS)
do
    echo -e "\n==============================Scanning $host======================================\n"
    nmap -sS -sC -sV -O $host -oN OUTPUTS/$host-INTENSE-SCAN
    echo -e "\n=============================$host End of Scan===============================\n"
done

}


if [ -z $1 ]; then
    echo "Usage: <script.sh> <IP> <Subnet> <Domain>"
    echo "sudo ./host-discovery.sh 10.10.10.0 24 domain.com"
else
    echo -e "[*] Scanning $IP/$MASK\n"
    echo -e "\n===================SWEEP-SCAN===========================\n"
    find_alive_hosts
    echo -e "\n================SWEEP-SCAN-NO-PING=======================\n"
    no_ping
    echo -e "\n=============FINDING HOST WITH PORT 53 OPEN=============\n"
    dns_discovery
    if [ ! -z $3 ]; then
        echo -e "\n=================BASIC-DNS-ENUMERATION===================\n"
        dns_enum
    fi
    echo -e "\n==================NMAP INTENSE SCAN=====================\n"
    nmap_scan
fi
