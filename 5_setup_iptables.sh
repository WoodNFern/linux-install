#!/usr/bin/env bash
set -e

# This is a script setting up a basic iptables firewall ruleset.
# The rules and commands are taken from https://wiki.archlinux.org/index.php/simple_stateful_firewall

#Create user-defined chains for opening ports in the firewall called "TCP" and "UDP"
iptables -N TCP
iptables -N UDP

iptables -P OUTPUT ACCEPT   #Do not filter outgoing traffic
iptables -P FORWARD DROP    #Disable packet forwarding
iptables -P INPUT DROP      #Drop every incoming packet as per default



#########################
### INPUT CHAIN RULES ###
#########################

#Allow packets of and related to established connections
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#Allow all packets of loopback (lo) interface
iptables -A INPUT -i lo -j ACCEPT

#Exception to upcoming "INVALID" rule. Allows ICMPv6 Neighbor Discovery
iptables -A INPUT -p 41 -j ACCEPT

#Drop all "INVALID" packets
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

#Allow ICMP echo requests (ping). Rule applies for first packet only, rest handled b RELATED/ESTABLISHED
iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT

#Add user-defined "TCP"/"UDP" chains to INPUT chain.
iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

#Define REJECT behavior: TCP -> TCP RESET packet; UDP -> ICMP port unreachable
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset

#For other protocolls: reject all remaining incoming traffic with ICMP unreachable messages
iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable



#######################
### TCP CHAIN RULES ###
#######################

#Allow incoming connections to a web server (Port 80/443)
# iptables -A TCP -p tcp --dport 80 -j ACCEPT
# iptables -A TCP -p tcp --dport 443 -j ACCEPT

#Allow incoming SSH connections (Port 22)
# iptables -A TCP -p tcp --dport 22 -j ACCEPT

#Allow for incoming DNS requests (Port 53)
# iptables -A TCP -p tcp --dport 53 -j ACCEPT
# iptables -A UDP -p udp --dport 53 -j ACCEPT


######################################
### SAVE RULES & ACTIVATE IPTABLES ###
######################################

sudo sh subscripts/activate_iptables.sh
