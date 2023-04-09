#!/usr/bin/env bash

# This script performs the following:
# - Installs list of packages from pacman in given file

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

echo "Enter file name: "
read -r FILE

echo "Installing packages from $FILE"
pacman -S --needed - < $FILE
echo "Installed packages from $FILE"
