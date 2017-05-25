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
read -p "Please enter the name of this computer: " HOSTNAME
echo ${HOSTNAME} > /etc/hostname
echo

echo "Setting locale..."
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo LANGUAGE=en_US >> /etc/locale.conf

echo "Setting keyboard layout..."
echo KEYMAP=de-latin1 > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf

echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Show hosts and resolv.conf
echoSeperator
echo "Current configuration of '/etc/hosts':"
echo
cat /etc/hosts
echoSeperator
echo "Current configuration of '/etc/resolv.conf':"
echo
cat /etc/resolv.conf
echoSeperator

# Generate locales
echo "Generating localization encodings..."
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
echo "de_DE ISO-8859-1" >> /etc/locale.gen
echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen
echoSeperator

echo "Creating linux kernel"
echo
mkinitcpio -p linux
echoSeperator

# Set root password
echo "Please enter and confirm your root password."
passwd
echo
