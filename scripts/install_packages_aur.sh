#!/usr/bin/env bash

# This script performs the following:
# - Installs list of packages from AUR in packages-aur.txt

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# if yay is not installed, install it
if ! command -v yay &> /dev/null; then
    echo "Installing yay"
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si
    cd ..
    rm -rf yay
    echo "Installed yay"
fi

echo "Enter file name: "
read -r FILE

echo "Installing packages from $FILE"
yay -S --needed - < $FILE
echo "Installed packages from $FILE"