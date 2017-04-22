#!/usr/bin/env bash

function echoSeperator {
	echo
	echo "================================================================="
	echo
}

## Install GRUB bootloader
# Download and install GRUB
echoSeperator
echo "Installing GRUB bootloader..."
echoSeperator

pacman -S --noconfirm efibootmgr dosfstools gptfdisk grub

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck --debug
mkdir -p /boot/grub/locale
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

# Create grub configuration.
grub-mkconfig -o /boot/grub/grub.cfg
