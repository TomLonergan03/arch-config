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
cp ~/.config/fish/config.fish $BACKUPFOLDER
cp ~/.gitconfig $BACKUPFOLDER/saved.gitconfig
sudo cp /etc/hosts $BACKUPFOLDER
sudo cp -r /var/lib/iwd $BACKUPFOLDER/wifi
sudo chown -R $WHOAMI:$WHOAMI $BACKUPFOLDER/wifi
echo "Saved bashrc, fish config, gitconfig, hosts, wifi to $BACKUPFOLDER"

echo $(sudo pacman -Qent) | tr " " "\n" | sed '0~2d' > $BACKUPFOLDER/packages-pacman.txt
echo $(sudo pacman -Qemt) | tr " " "\n" | sed '0~2d' > $BACKUPFOLDER/packages-foreign.txt
echo "Saved lists of explicitly installed packages to $BACKUPFOLDER"