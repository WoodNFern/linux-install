#!/usr/bin/env bash
#
# This script is intended to perform some initialization tasks for an Arch Linux
# automatically with minimal user interaction and install some common software. 
# Certain configurations are personal preference and may be adapted.
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



function addSudoUser {
	# Add a non-root user
	echoSeperator
	echo "Adding a new user..."
	echo
	read -p "Please enter the name of the user (small letters only)" USERNAME
	useradd -m -g users -s /bin/bash ${USERNAME}
	passwd ${USERNAME}

	# Enable sudo
	echo
	echo "Enabling 'sudo' functionality..."
	echo
	pacman -S --noconfirm sudo
	echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

	# Add user to important groups
	echo "Add user to important groups..."
	gpasswd -a ${USERNAME} wheel
	gpasswd -a ${USERNAME} audio
	gpasswd -a ${USERNAME} video
	gpasswd -a ${USERNAME} games
	gpasswd -a ${USERNAME} power
	echo
}



function installMiscServices {
	# Install  and enable additional services
	echoSeperator
	echo "Install and enable useful services..."
	echoSeperator
	pacman -S --noconfirm acpid ntp dbus avahi cups cronie networkmanager
	systemctl enable acpid
	systemctl enable ntpd
	systemctl enable avahi-daemon
	systemctl enable org.cups.cupsd.service
	systemctl enable NetworkManager.service
	systemctl enable cronie
}



function setupNTP {
	# Set up NTP
	echoSeperator
	echo "Installing NTP..."
	echo
	pacman -S --noconfirm ntp
	echoSeperator
	echo "Adding german NTP server to /etc/ntp.conf ..."
	echo 'de.pool.ntp.org' | cat - /etc/ntp.conf > temp_file && mv temp_file /etc/ntp.conf
	nano /etc/ntp.conf

	ntpd -gq
	echoSeperator
	echo "The current time / date is:"
	date
	echoSeperator
	hwclock -w
}



function installXorgComponents {
	echoSeperator
	echo "Installing necessary X components"
	echoSeperator
	pacman -S --noconfirm xorg-server xorg-xinit

	echoSeperator
	echo "Installing device driver for Intel chips..."
	echoSeperator
	pacman -S --noconfirm xf86-video-intel

	echoSeperator
	echo "Installing touchpad driver..."
	echoSeperator
	pacman -S --noconfirm xf86-input-synaptics

	echoSeperator
	echo "Setting keymap..."
	echoSeperator
	localectl set-x11-keymap de acer_laptop de_nodeadkeys

	echoSeperator
	echo "Installing nice fonts..."
	echoSeperator
	pacman -S --noconfirm ttf-dejavu ttf-inconsolata ttf-liberation ttf-symbola terminus-font
}



function install_gnome {
	pacman -S --noconfirm gnome gnome-extra
	echo "exec gnome-session" > ~/.xinitrc
	systemctl enable gdm
}

function install_xfce4 {
	pacman -S --noconfirm xfce4 xfce4-goodies human-icon-theme
	echo "exec startxfce4" > ~/.xinitrc
	pacman -S --noconfirm slim
	#	It might happen that you need to uncomment the line
	# 	'sessiondir /usr/share/xsessions/' in /etc/slim.conf
	systemctl enable slim
}

function installWindowManager {
	echoSeperator
	PS3='Which window manager do you want to install? '
	options=("GNOME" "Xfce4")
	select opt in "${options[@]}"
	do
	    case $opt in
		"GNOME")
		    echo "Installing GNOME..."
		    		echoSeperator
				install_gnome
				break
		    ;;
		"Xfce4")
		    echo "Installing Xfce4..."
		    		echoSeperator
				install_xfce4
				break
		    ;;
		*) echo "Invalid option";;
	    esac
	done
}



function installALSA {
	echoSeperator
	echo "Installing ALSA (Advanced Linux Sound Architecture)..."
	echoSeperator
	pacman -S --noconfirm alsa-utils
}



function installACPISupport {
	echoSeperator
	echo "Install ACPI support for notebooks"
	echoSeperator
	pacman -S --noconfirm acpid
	echoSeperator
	echo "Enabling ACPI service..."
	echoSeperator
	sudo systemctl enable acpid
	sudo systemctl start acpid
}

# Reestablish network connection
wifi-menu

addSudoUser

installMiscServices

setupNTP

installXorgComponents

installWindowManager

installALSA

installACPISupport
