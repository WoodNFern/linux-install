#!/usr/bin/env bash
#
# This script is intended to install some common software for an Arch Linux
# automatically with minimal user interaction and install some common software. 
# Certain configurations are personal preference and may be adapted.
#
set -e

# Needed software
sudo pacman -S openssh \
rsync \
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

# Add kernel module
echo "Please enter your username to be able to use VirtualBox"
read USERNAME
sudo sh -c 'echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf'
sudo gpasswd -a ${USERNAME} vboxusers

## Install 'yaourt' for AUR packages

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

yaourt -S exaile 
