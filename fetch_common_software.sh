#!/usr/bin/env bash
#
# This script is intended to install some common software for an Arch Linux
# automatically with minimal user interaction and install some common software. 
# Certain configurations are personal preference and may be adapted.
#
set -e

# Needed software
sudo pacman -S openssh \
keepass \
wget \
firefox firefox-i18n-de \
thunderbird thunderbird-i18n-de \
libreoffice-still libreoffice-still-de \
gimp \
inkscape \
vlc \
texlive-most texlive-lang texmaker \
brasero

#yaourt -S exaile 
