#!/usr/bin/env bash

# This script performs the following:
# - Installs list of packages from pacman in given file

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

echo "Installing packages from $1"
pacman -S --needed - < $1
echo "Installed packages from $1"
