#!/bin/bash

#sudo iptables -F && sudo iptables -X
#sudo iptables-restore < firewall_vpn


# Remove any existing rules
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
#sudo iptables -t nat -F
#sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
#sudo ip6tables -P INPUT ACCEPT
#sudo ip6tables -P FORWARD ACCEPT
#sudo ip6tables -P OUTPUT ACCEPT
#sudo ip6tables -t nat -F
#sudo ip6tables -t mangle -F
#sudo ip6tables -F
#sudo ip6tables -X

# Allow loopback device (internal communication)
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allow all local traffic
sudo iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
sudo iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT

# Allow DNS (could be VPN provider or someone like Cloudflare's 1.1.1.1)
#sudo iptables -A OUTPUT -d [Primary DNS IP here] -j ACCEPT
#sudo iptables -A OUTPUT -d [Secondary DNS IP here] -j ACCEPT
sudo iptables -A OUTPUT -d 10.204.0.1 -j ACCEPT
sudo iptables -A OUTPUT -d 8.8.8.8 -j ACCEPT
sudo iptables -A OUTPUT -d 1.1.1.1 -j ACCEPT

# Allow related and established connections
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Allow VPN establishment
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT
sudo iptables -A OUTPUT -p udp --dport 1198 -j ACCEPT
sudo iptables -A INPUT -p udp --sport 1198 -j ACCEPT
sudo iptables -A OUTPUT -p udp --dport 1194 -j ACCEPT
sudo iptables -A INPUT -p udp --sport 1194 -j ACCEPT

# Accept all tun0 (VPN tunnel) connections
sudo iptables -A OUTPUT -o tun0 -j ACCEPT
sudo iptables -A INPUT -i tun0 -j ACCEPT

# Allow for nslookup to not throw an error
#sudo ip6tables -I OUTPUT 1 -p udp -s 0000:0000:0000:0000:0000:0000:0000:0001 -d 0000:0000:0000:0000:0000:0000:0000:0001 -j ACCEPT

# Drop everything else (ipv4)
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

# Drop everything (ipv6)
#sudo ip6tables -P INPUT DROP
#sudo ip6tables -P OUTPUT DROP
#sudo ip6tables -P FORWARD DROP
