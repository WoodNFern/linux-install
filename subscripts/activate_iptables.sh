#!/usr/bin/env bash
set -e

sudo sh -c 'iptables-save > /etc/iptables/iptables.rules'
systemctl enable iptables.service
systemctl start iptables.service
