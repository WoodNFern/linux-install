#!/usr/bin/env bash
#
# This script is intended to be used to configure an Arch Linux
# automatically with minimal user interaction. Certain configurations are 
# personal preference and may be adapted.
#
# The contents of this script are derived from the installation guide provided
# by https://wiki.archlinux.de/title/Anleitung_f%C3%BCr_Einsteiger
#
set -e

function echoSeperator {
	echo
	echo "================================================================="
	echo
}

# Set host name
echo "Please enter the name of this computer:"
read HOSTNAME
echo ${HOSTNAME} > /etc/hostname

# Set locale 
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo LANGUAGE=en_US >> /etc/locale.conf

# Set keyboard layout (intermediate)
echo KEYMAP=de-latin1 > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf

# Set local time (here it is Germany's timezone)
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Show hosts and resolv.conf
echo "Current configuration of '/etc/hosts':"
echo
cat /etc/hosts

echo "Current configuration of '/etc/resolv.conf':"
echo
cat /etc/resolv.conf

# Generate locales
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
echo "de_DE ISO-8859-1" >> /etc/locale.gen
echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
nano /etc/locale.gen
locale-gen

# Create linux kernel 
mkinitcpio -p linux

# Set root password
echo "Please enter and confirm your root password."
passwd
