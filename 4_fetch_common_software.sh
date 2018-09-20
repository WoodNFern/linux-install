#!/usr/bin/env bash
#
# This script is intended to install some common software for an Arch Linux
# automatically with minimal user interaction and install some common software. 
# Certain configurations are personal preference and may be adapted.
#
set -e

function echoSeperator {
	echo
	echo "================================================================="
	echo
}

## Configure zsh (more info: https://wiki.gnome.org/Apps/Terminal/FAQ)
function configureZSH {
	echoSeperator
	echo "Installing 'OhMyZSH!'..."
	echoSeperator
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	# Set zsh as default
	echoSeperator
	echo "Setting 'zsh' as default shell..."
	echoSeperator
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

	echoSeperator
	echo "Setting color theme for the terminal..."
	echoSeperator

	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${GNOME_PROFILE_ID:1:-1}/ use-theme-colors false
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${GNOME_PROFILE_ID:1:-1}/ palette "${PALETTE}"
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${GNOME_PROFILE_ID:1:-1}/ background-color "${BACKGROUND_COLOR}"
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${GNOME_PROFILE_ID:1:-1}/ foreground-color "${TEXT_COLOR}"

	echo "Terminal colors have been set to theme 'solarized'"
	echo "You may want to use 'agnoster' theme from 'Oh My ZSH!'. This can be configured in ~/.zshrc"
}

## Set kernel modules needed for virtualbox to be started automatically
function setAutorunVBoxKernelModules {
	# Add kernel module for virtualbox
	echoSeperator
	echo "Adding kernel modules for virtualbox"
	echoSeperator
	sudo sh -c 'echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf'
	sudo sh -c 'echo "vboxnetadp" >> /etc/modules-load.d/virtualbox.conf'
	sudo sh -c 'echo "vboxnetflt" >> /etc/modules-load.d/virtualbox.conf'

	read -p "Please enter your username to be able to use VirtualBox: " USERNAME
	sudo gpasswd -a ${USERNAME} vboxusers
}

## Install 'yaourt' for AUR packages
function installAUR {
	echoSeperator
	echo "Installing 'package-query' for yaourt..."
	echoSeperator
	curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
	tar -xvzf package-query.tar.gz
	cd package-query
	makepkg -si
	cd ..

	echoSeperator
	echo "Installing 'yaourt'..."
	echoSeperator
	curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
	tar -xvzf yaourt.tar.gz
	cd yaourt
	makepkg -si
}

function installAurPackages {    
    yaourt -S exaile
    
    gpg --recv-keys DB1187B9DD5F693B #Import GPG key of enigmail dev
    yaourt -S thunderbird-enigmail
    
    yaourt -S android-studio
    yaourt -S icdiff					# Colorful, readable diff
    yaourt -S masterpdfeditor				# Edit PDFs
}

## Install basic software packages for everyday use
function installCommonPacmanPackages {
	echoSeperator
	echo "Installing commonly used software..."
	echoSeperator

	# Basics
	sudo pacman -S --noconfirm zsh
	sudo pacman -S --noconfirm powerline
	sudo pacman -S --noconfirm powerline-fonts
	sudo pacman -S --noconfirm firefox
	sudo pacman -S --noconfirm firefox-i18n-de
	sudo pacman -S --noconfirm thunderbird
	sudo pacman -S --noconfirm thunderbird-i18n-de
	#sudo pacman -S --noconfirm virtualbox

	# Media
	sudo pacman -S --noconfirm gimp
	sudo pacman -S --noconfirm inkscape
	sudo pacman -S --noconfirm vlc
	sudo pacman -S --noconfirm brasero              # Burning CD/DVD

	# Development tools
	sudo pacman -S --noconfirm jdk8-openjdk
	sudo pacman -S --noconfirm wget
	sudo pacman -S --noconfirm sshfs
	sudo pacman -S --noconfirm openssh
	sudo pacman -S --noconfirm rsync
	sudo pacman -S --noconfirm jq			# CLI JSON processor
	sudo pacman -S --noconfirm httpie		# Good looking cURL wrapper

	# Productivity
	sudo pacman -S --noconfirm ranger               # Terminal file manager
	sudo pacman -S --noconfirm keepass              # Password manager
	sudo pacman -S --noconfirm fd			# Human-friendly find
	sudo pacman -S --noconfirm exa			# More informative 'ls' alternative
	sudo pacman -S --noconfirm progress		# Show progress for running fs operations
	sudo pacman -S --noconfirm ncdu			# 'graphical' disk usage analyzer
	sudo pacman -S --noconfirm texlive-most
	sudo pacman -S --noconfirm texlive-lang
	sudo pacman -S --noconfirm texmaker
	sudo pacman -S --noconfirm libreoffice-still
	sudo pacman -S --noconfirm libreoffice-still-de

	# Everday Life
	sudo pacman -S --noconfirm gourmet

	# Fun
	sudo pacman -S --noconfirm fortune-mod          # fortune cookie generator
	sudo pacman -S --noconfirm cowsay               # Wraps messages into a talking cow
	sudo pacman -S --noconfirm bsd-games 		# Collection of fun utilities
}

installCommonPacmanPackages

configureZSH

setAutorunVBoxKernelModules

installAUR

installAurPackages

echoSeperator
echo "Finished installing software!"
echoSeperator
