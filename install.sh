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
echo "Loading keyboard layout '/usr/share/kbd/keymaps/i386/qwertz/de-mobii.map.gz'"
loadskeys /usr/share/kbd/keymaps/i386/qwertz/de-mobii.map.gz



## Setup WiFi
echo "Setting up WiFi connection..."
echo
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



## Install the basic system
echo "Installing the basic system"

# Select appropriate mirrors
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

echo "Select the download mirrors you want to use with PACMAN."
echo "Continue with 'Enter'"
read
nano /etc/pacman.d/mirrorlist

# Install basic packages
# package 'intel-ucode' is useful for machines running on intel chips
# package 'wpa_supplicant' may be usefull to avoid WiFi problems during/after
#	installation.
echo "Installing basic packages..."
pacstrap /mnt base base-devel wpa_supplicant intel-ucode

# Generate file system table
echo "Generating file system table..."
genfstab -p /mnt > /mnt/etc/fstab

echo "The generated file system table looks as follows:"
echo
cat /mnt/etc/fstab
echo

echo "NOTE: If you have installed Arch-Linux on a SSD, it is advised to change
the file system table to mount '/' with options 'rw,defaults,noatime,discard'
and mount 'swap' with options 'defaults,noatime,discard'."
echo
echo "Installation is now complete."
echo "Entering operating system environment..."
arch-chroot /mnt/