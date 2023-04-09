#!/usr/bin/env bash

# This script performs the following:
# Creates a user with the provided username and password

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

echo "Enter username: "
read -r username
echo "Enter password: "
read -r -s password
useradd -m -g users -G wheel $username -p $password