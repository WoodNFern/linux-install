#!/usr/bin/env bash
#
# This script is intended to install some common software for an Arch Linux
# automatically with minimal user interaction and install some common software. 
# Certain configurations are personal preference and may be adapted.
#
set -e

## Configure zsh (more info: https://wiki.gnome.org/Apps/Terminal/FAQ)
function configureZSH {
	#Install .oh-my-zsh
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	# Set zsh as default
	chsh -s /bin/zsh

	# Get profile ID of Gnome settings profile
	GNOME_PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default)
	# Colour palette of 'solarized' theme
	PALETTE="['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', \
	'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', \
	'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', \
	'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', \
	'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', \
	'rgb(253,246,227)']"
	# Terminal background
	BACKGROUND_COLOR="'rgb(0,43,54)'"
	#Terminal text color
	TEXT_COLOR="'rgb(131,148,150)'"

	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${GNOME_PROFILE_ID:1:-1}/ use-theme-colors false
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${GNOME_PROFILE_ID:1:-1}/ palette "${PALETTE}"
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${GNOME_PROFILE_ID:1:-1}/ background-color "${BACKGROUND_COLOR}"
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${GNOME_PROFILE_ID:1:-1}/ foreground-color "${TEXT_COLOR}"

	echo "Terminal colors have been set to theme 'solarized'"
	echo "You may want to use 'agnoster' theme from 'Oh My ZSH!'. This can be configured in ~/.zshrc"
}

## Set kernel modules needed for virtualbox to be started automatically
function setAutorunVBoxKernelModules {
	# Add kernel module
	echo "Please enter your username to be able to use VirtualBox"
	read USERNAME
	sudo sh -c 'echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf'
	sudo sh -c 'echo "vboxnetadp" >> /etc/modules-load.d/virtualbox.conf'
	sudo sh -c 'echo "vboxnetflt" >> /etc/modules-load.d/virtualbox.conf'
	sudo gpasswd -a ${USERNAME} vboxusers
}

## Install 'yaourt' for AUR packages
function installAUR {
	# Install 'package-query' (dependency of yaourt)
	curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
	tar -xvzf package-query.tar.gz
	cd package-query
	makepkg -si
	cd ..

	# Install 'yaourt'
	curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
	tar -xvzf yaourt.tar.gz
	cd yaourt
	makepkg -si
}

## Install basic software packages for everyday use
function installCommonPacmanPackages {
	sudo pacman -S zsh \
	openssh \
	rsync \
	sshfs \
	keepass \
	wget \
	jdk8-openjdk \
	firefox firefox-i18n-de \
	thunderbird thunderbird-i18n-de \
	libreoffice-still libreoffice-still-de \
	gimp \
	inkscape \
	vlc \
	texlive-most texlive-lang texmaker \
	brasero \
	virtualbox
}

installCommonPacmanPackages
configureZSH
setAutorunVBoxKernelModules
installAUR

yaourt -S exaile
