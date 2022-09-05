
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

- Resource records
- TTL
- Record Class
- SOA
- NS
- A 
- PTR 
- CNAME
- MX

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

## DNSRecon

```bash
dnsrecon -d mydomain.com
```



## Tools references

 - [ICANN](https://www.icann.org/)
 - [DNS Queries](https://www.dnsqueries.com/en)
 - [MX Toolbox](https://mxtoolbox.com/)
 

