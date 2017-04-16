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

# Add a non-root user
echo "Adding a new user..."
echo "Please enter the name of the user (small letters only)"
read USERNAME
useradd -m -g users -s /bin/bash ${USERNAME}

# Enable sudo
echo "Enabling 'sudo' functionality..."
echo
pacman -S sudo
echo "Uncomment the line 'wheel ALL=(ALL) ALL' to enable sudo access for you"
echo "Press 'Enter' to continue"
read
nano /etc/sudoers

# Add user to important groups
echo "Add user to important groups..."
gpasswd -a ${USERNAME} wheel
gpasswd -a ${USERNAME} audio
gpasswd -a ${USERNAME} video
gpasswd -a ${USERNAME} games
gpasswd -a ${USERNAME} power

# Install  and enable additional services
echo "Install and enable useful services..."
echo
pacman -S acpid ntp dbus avahi cups cronie
systemctl enable acpid
systemctl enable ntpd
systemctl enable avahi-daemon
systemctl enable org.cups.cupsd.service
systemctl enable NetworkManager.service
systemctl enable cronie

# Set up NTP
echo "Installing NTP..."
echo
pacman -S ntp
echo "You may now enter a different time server (e.g. de.pool.ntp.org)"
echo "Press 'Enter' to continue"
read
nano /etc/ntp.conf

ntpd -gq
echo "The current time / date is:"
date
hwclock -w



## Install X and other components
echo "Installing necessary X components"
pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils

echo "Installing device driver for Intel chips..."
pacman -S xf86-video-intel

echo "Installing touchpad driver..."
pacman -S xf86-input-synaptics

echo "Setting keymap..."
localeectl set-x11-keymap de acer_laptop de_nodeadkeys

echo "Installing nice fonts..."
pacman -S ttf-dejavu ttf-inconsolata ttf-liberation ttf-symbola terminus-font



## Install window manager

function install_gnome {
	pacman -S gnome gnome-extra
	echo "exec gnome-session" > ~/.xinitrc
	systemctl enable gdm
}

function install_xfce4 {
	pacman -S xfce4 xfce4-goodies human-icon-theme
	echo "exec startxfce4" > ~/.xinitrc
	pacman -S slim
	#	It might happen that you need to uncomment the line
	# 	'sessiondir /usr/share/xsessions/' in /etc/slim.conf
	systemctl enable slim
}

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



## Install ALSA
echo "Installing ALSA (Advanced Linux Sound Architecture)..."
pacman -S alsa-utils



## MISC

# ACPI support for notebooks
pacman -S acpid
sudo systemctl enable acpid
sudo systemctl start acpid

# Needed software
sudo pacman -S firefox firefox-i18n-de \
thunderbird thunderbird-i18n-de \
libreoffice-still libreoffice-still-de \
gimp \
inkscape \
vlc \
texlive-most texlive-lang texmaker \
brasero

#yaourt -S exaile 