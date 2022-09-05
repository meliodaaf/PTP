
# Information Gathering

PTP Notes for Information Gathering
## Infrastructure 

- Domains
- Netblocks or IP addresses
- Mail Servers
- ISPs


## WHOIS

Detemine the following information. Typically runs on TCP port 43.

- The owner of the domain name
- IP address or range
- Autonomous System
- Technical Contacts
- Expiration date of the domain

```bash
whois domain.com
```
```bash
whois -h whois.godaddy.com domain.com
```

## DNS

DNS is key aspect of Information Security as it binds a hostname to an IP address.

| Name      | Description                                                   |
| :-------- | :------------------------------------------------------------ |
| `Resource records` | `Starts with a domain name, usually FQDN`            |
|`TTL`| `Recorded in seconds, defaults to the minimun defined in SOA`       |
|`Record Class`| `Internet, Hesiod, Chaod`                                  |
|`SOA`|`Indicates the beginning of a zone`                                  |
|`NS`|`Defines an authoritative name server for a zone`                     |
|`A`|`Maps a hostname to an IP address`                                     |
|`PTR`| `Maps an IP address to a hostname`                                  |
|`CNAME`| `Maps an alias hostname to an A record hostname`                  |
|`MX`| `Specifies host that will accept email on behalf of a given hostname`|

## DNS Lookup

```bash
nslookup mydomain.com
```
```bash
dig mydomain.com +short
```

## Reverse DNS Lookup

```bash
nslookup -type=PTR IPaddress
```
```bash
dig IPaddress PTR
```

## Mail Exchange Lookup

```bash
nslookup -type=MX domain
```
```bash
dig +nocmd IPaddress MX +noall +answer
```

## Zone Transfer

```bash
nslookup -type=NS domain.com
```

```bash
nslookup
server NAMESERVER for domain.com
ls -d mydomain.com
```
```bash
dig axfr NAMESERVER domain.com
```

# DNS Reconnaissance Tools

## Fierce

```bash
fierce -dns mydomain.com
```
```bash
fierce -dns mydomain.com -dnsserver ns1.mydomain.com
```

## DNSEnum

```bash
dnsenum mydomain.com
```
```bash
dnsenum mydomain.com --dnsserver ns1.mydomain.com
```

## DNSMap

```bash
dnsmap mydomain.com
```
```bash
dnsmap domain.com -w wordlist.txt
```
## DNSRecon

```bash
dnsrecon -d mydomain.com
```

# Ping sweep tools

- Determine hosts IP that are alive
- Determine if they have associated hostname of domain


## FPING

| Argument               | Description                                                  |
| :--------------------- | :------------------------------------------------------------|
| `-a, --alive`          | `show targets that are alive`                                |
|`-g, --generate`        | `generate target list`                                       |
|`-A, --addr`            | `show targets by address`                                    |
|`-q, --quiet`           |`quiet (don't show per-target/per-ping results)`              |
|`-e, --elapsed`         | `show elapsed time on return packets`                        |
|`-r, --retry`           | `number of retries (default: 3)`                             |

```bash
fping -a -g 192.168.1.0/24
```
```bash
fping -A 192.168.1.0/24 -r 0 -e
```
```bash
fping -q -a -g 192.168.1.0/24 -r 0 -e
```
## NMAP

| Argument               | Description                                                   |
| :--------------------- | :------------------------------------------------------------ |
| `-sn`                  | `Ping Scan - disable port scanth a domain name, usually FQDN` |
|`-PS/PA/PU/PY[portlist]`| `TCP SYN/ACK, UDP or SCTP discovery to given ports`           |
|`-sS`                   | `TCP Syn Scan`                                                |
|`-sU`                   |`UDP Syn Scan`                                                 |
|`-n/-R`                    | `Never do DNS resolution/Always resolve`                   |

```bash
sudo nmap -sn 10.0.0.0/24
```
```bash
sudo nmap -sn -PS 192.168.1.1 --disable-arp-ping
```
```bash
nmap -sS -p53 [netblock]
nmap -sU -p53 [netblock]
```
## HPING3

```bash
sudo hping3 -1 192.168.1.1 -c 3
```

```bash
sudo hping3 --icmp-ts 192.168.1.1 -c 3 -V
```
```bash
sudo hping3 -2 192.168.1.1 -c 3 -V
```
```bash
sudo hping3 -S 192.168.1.1 -c 3
```
```bash
sudo hping3 -1 192.168.1.x --rand-dest -I eth0
```


## Tools references

 - [ICANN](https://www.icann.org/)
 - [DNS Queries](https://www.dnsqueries.com/en)
 - [MX Toolbox](https://mxtoolbox.com/)
 - [NMAP Host Discovery](https://nmap.org/book/man-host-discovery.html)
 - [DNS Dumpster](https://dnsdumpster.com/)

 

