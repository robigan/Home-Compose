#!/bin/bash

# Fetch IPv4 and IPv6 addresses from Cloudflare and format as comma-separated CIDR list

ipv4=$(curl -s https://www.cloudflare.com/ips-v4/)
ipv6=$(curl -s https://www.cloudflare.com/ips-v6/)

# Combine both outputs and convert newlines to commas
echo -e "${ipv4}\n${ipv6}" | tr '\n' ',' | sed 's/,$//'
