#!/usr/bin/env bash
#
# This script is intended to be used to install and configure an Arch Linux
# automatically with minimal user interaction. Certain configurations are 
# personal preference and may be adapted.
#
# The contents of this script are derived from the installation guide provided
# by https://wiki.archlinux.de/title/Anleitung_f%C3%BCr_Einsteiger
#

## Use correct keyboard layout for my German laptop in case of user interaction
loadskeys /usr/share/kbd/keymaps/i386/qwertz/de-mobii.map.gz



## Setup WiFi
ip link
echo "Which WiFi interface do you want to use?"
echo
read WIFI_ADAPTER

echo "What is the SSID of the network?"
echo
read SSID

echo "What is the password for the network?"
echo
read -s WIFI_PASSWORD

# Use provided logins to connect to the network with the specified WiFi adapter.
# Selected device driver is 'wext' because of wider support.
wpa_passphrase ${SSID} ${WIFI_PASSWORD} > /etc/wpa_supplicant/wpa_supplicant.conf
wpa_supplicant -i ${WIFI_ADAPTER} -D wext -c /etc/wpa_supplicant/wpa_supplicant.conf -B
dhcpcd ${WIFI_ADAPTER}

# Alternatively 'wifi-menu' can be used
# wifi-menu
