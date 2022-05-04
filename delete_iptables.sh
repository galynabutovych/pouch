#!/bin/bash

sudo iptables -F && sudo iptables -X
sudo iptables-restore < firewall_acceptall
