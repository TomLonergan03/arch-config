#!/usr/bin/env bash

# This script will extract the configuration files from the computer it is run on
# The files will be stored in a folder named $HOSTNAME-$WHOAMI-yyyy-mm-dd-HHMMSS
# The resulting folder will contain files with the following:
# - /etc/hosts
# - fish config files
# - git config files
# - bash config files
# - general setup files
# - list of explicitly installed packages from pacman, aur, and pip
#      - you might want to edit what packages are installed on the new computer

HOSTNAME=$(hostname)
WHOAMI=$(whoami)
BACKUPFOLDER="$HOSTNAME-$WHOAMI-$(date +%Y-%m-%d-%H:%M:%S)"
mkdir $BACKUPFOLDER
cp ~/.bashrc $BACKUPFOLDER/saved.bashrc
cp -r ~/.config/fish $BACKUPFOLDER
cp ~/.gitconfig $BACKUPFOLDER/saved.gitconfig
sudo cp /etc/hosts $BACKUPFOLDER
sudo cp -r /var/lib/iwd $BACKUPFOLDER/wifi
sudo chown -R $WHOAMI:$WHOAMI $BACKUPFOLDER/wifi
cp -r ~/.config/hypr $BACKUPFOLDER
cp -r ~/.config/nvim $BACKUPFOLDER
cp -r ~/.config/dunst $BACKUPFOLDER
cp -r ~/.config/kitty $BACKUPFOLDER
cp -r ~/.config/waybar $BACKUPFOLDER
echo "Saved dotfiles to $BACKUPFOLDER"

echo $(sudo pacman -Qent) | tr " " "\n" | sed '0~2d' | tr "\n" " " > $BACKUPFOLDER/packages-pacman.txt
echo "Saved lists of explicitly installed packages to $BACKUPFOLDER"
echo $(sudo pacman -Qemt) | tr " " "\n" | sed '0~2d' | tr "\n" " " > $BACKUPFOLDER/packages-foreign.txt
echo "Saved lists of explicitly installed foreign packages to $BACKUPFOLDER"