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
	echo "Adding a new user..."
	echo "Please enter the name of the user (small letters only)"
	read USERNAME
	useradd -m -g users -s /bin/bash ${USERNAME}
	passwd ${USERNAME}

	# Enable sudo
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
}



function installMiscServices {
	# Install  and enable additional services
	echo "Install and enable useful services..."
	echo
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
	echo "Installing NTP..."
	echo
	pacman -S --noconfirm ntp
	echo "You may now enter a different time server (e.g. de.pool.ntp.org)"
	echo "Press 'Enter' to continue"
	read
	nano /etc/ntp.conf

	ntpd -gq
	echo "The current time / date is:"
	date
	hwclock -w
}



function installXorgComponents {
	## Install X and other components
	echo "Installing necessary X components"
	pacman -S --noconfirm xorg-server xorg-xinit xorg-utils xorg-server-utils

	echo "Installing device driver for Intel chips..."
	pacman -S --noconfirm xf86-video-intel

	echo "Installing touchpad driver..."
	pacman -S --noconfirm xf86-input-synaptics

	echo "Setting keymap..."
	localectl set-x11-keymap de acer_laptop de_nodeadkeys

	echo "Installing nice fonts..."
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
	PS3='Which window manager do you want to install? '
	options=("GNOME" "Xfce4")
	select opt in "${options[@]}"
	do
	    case $opt in
		"GNOME")
		    echo "Installing GNOME..."
				install_gnome
				break
		    ;;
		"Xfce4")
		    echo "Installing Xfce4..."
				install_xfce4
				break
		    ;;
		*) echo "Invalid option";;
	    esac
	done
}



function installALSA {
	echo "Installing ALSA (Advanced Linux Sound Architecture)..."
	pacman -S --noconfirm alsa-utils
}



function installACPISupport {
	pacman -S --noconfirm acpid
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
