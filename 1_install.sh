#!/usr/bin/env bash
#
# This script is intended to be used to install and configure an Arch Linux
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



## Check for clutter on EFI partition /mnt/boot
function detectGarbageBootFiles {
	if [ -e "/mnt/boot/vmlinuz-linux" ] || [ -e "/mnt/boot/intel-ucode.img"]
	then
		echoSeperator
		echo "Detected residue files from previous installations in your EFI
			partition."
		echo "These files will cause problems during the installation."
		echo "Please remove the following files, if present:"
		echo "/mnt/boot/vmlinuz-linux"
		echo "/mnt/boot/intel-ucode.img"
		echo "Exiting installation now. You may resume after these files have
			been deleted."
		echoSeperator
		exit
	fi
}



function printWelcomeMessage {
	echoSeperator
	echo "Welcome to WoodNFern's installation script for Arch-Linux!"
	echo
	echo "Before running this installation, you have to partition your harddrive
	according to your needs and create the filesystems."
	echo
	while true; do
	    read -p "Have these steps been made? (y/N) " yn
	    case ${yn} in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) exit;;
	    esac
	done
}



function setupWifi {
	echoSeperator
	echo "Setting up WiFi connection..."
	echo
	ip link
	echoSeperator
	echo "Which WiFi interface do you want to use?"
	read -p "Name of the Wi-Fi adapter: " WIFI_ADAPTER
	echo
	echo "What is the SSID of the network?"
	read -p "Name (SSID) of the network: " SSID
	echo
	echo "What is the password for the network?"
	read -s -p "Password: " WIFI_PASSWORD
	echo
	echo "Connecting..."
	echoSeperator

	# Use provided logins to connect to the network with the specified WiFi adapter.
	# Selected device driver is 'wext' because of wider support.
	wpa_passphrase ${SSID} ${WIFI_PASSWORD} > /etc/wpa_supplicant/wpa_supplicant.conf
	wpa_supplicant -i ${WIFI_ADAPTER} -D wext -c /etc/wpa_supplicant/wpa_supplicant.conf -B
	dhcpcd ${WIFI_ADAPTER}

	echo
	echo "Success!"
	echo

	# Alternatively 'wifi-menu' can be used
	# wifi-menu
}



# Select appropriate mirrors
function setPacmanMirrors {

	echoSeperator
	echo "Looking for the fastest download mirrors for pacman..."
	echo "(This may take a few minutes)"

	# Backup
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

	# Uncomment all entries
	sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.bak

	# Set 5 fastest mirrors automatically
	rankmirrors -v -n 5 /etc/pacman.d/mirrorlist.bak | tee /dev/tty > /etc/pacman.d/mirrorlist
	echo "Done!"
}



# Install basic packages
function installBasicPackages {
	echoSeperator
	echo "Installing basic packages..."

	# package 'intel-ucode' is useful for machines running on intel chips
	# package 'wpa_supplicant' may be usefull to avoid WiFi problems during/after
	#	installation.
	# package 'dialog' is needed to be able to use 'wifi-menu' after reboot for
	#	easier WiFi setup.
	pacstrap /mnt base base-devel wpa_supplicant dialog intel-ucode

	echoSeperator
	echo "Generating file system table..."
	genfstab -Up /mnt > /mnt/etc/fstab

	echoSeperator
	echo "The generated file system table looks as follows:"
	echo
	cat /mnt/etc/fstab
	echoSeperator

	echo "NOTE: If you have installed Arch-Linux on a SSD, it is advised to change
	the file system table to mount '/' with options 'rw,defaults,noatime,discard'
	and mount 'swap' with options 'defaults,noatime,discard'."
	echo
	echo "Installation of the basic system is now complete. Don't exit the script yet."
	echo "Entering operating system environment..."
	echo
	echo "To continue the installation, run the script 'install_os_env.sh' next"
	echoSeperator
	arch-chroot /mnt/
}

## Use correct keyboard layout for my German laptop in case of user interaction
echo "Loading keyboard layout '/usr/share/kbd/keymaps/i386/qwertz/de-mobii.map.gz'"
loadkeys /usr/share/kbd/keymaps/i386/qwertz/de-mobii.map.gz

detectGarbageBootFiles

printWelcomeMessage

setupWifi

setPacmanMirrors

installBasicPackages
