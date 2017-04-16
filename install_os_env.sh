#!/usr/bin/env bash
#
# This script is intended to be used to install and configure an Arch Linux
# in the chroot environment after the basic system has been installed. Certain 
# configurations are personal preference and may be adapted.
#
# The contents of this script are derived from the installation guide provided
# by https://wiki.archlinux.de/title/Anleitung_f%C3%BCr_Einsteiger
#
set -e

## Run system configuration next
sh configure.sh

## Install GRUB bootloader
sh grub_install.sh



echo "The installation is now finished. The system should reboot now."
echo "Please run the following commands to reboot the system:"
echo "umount -R /mnt"
echo "reboot"
echo "Exiting operating system environment..."
exit

