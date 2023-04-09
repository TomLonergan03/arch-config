#!/usr/bin/env bash

# This script will install arch linux on a computer
# It should be run on the live usb
# It will install the following:
# - base
# - base-devel
# - linux
# - linux-firmware
# - nano
# - sudo

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

loadkeys uk
if [[ls /sys/firmware/efi/efivars >> /dev/null]]; then
    echo "System is UEFI"
else
    echo "System is not UEFI"
    exit 1
fi

echo "Set up internet connection? [y/n]"
read -r answer
while [[ $answer != "y" && $answer != "n" ]]; do
    echo "Invalid answer"
    echo "Set up internet connection? [y/n]"
    read -r answer
done
if [[ $answer == "y" ]]; then
    echo "Wifi or ethernet? [w/e]"
    read -r answer
    while [[ $answer != "w" && $answer != "e" ]]; do
        echo "Invalid answer"
        echo "Wifi or ethernet? [w/e]"
        read -r answer
    done
    if [[ $answer == "w" ]]; then
        sudo cp wifi /var/lib/iwd
        sudo systemctl enable iwd
        sudo systemctl start iwd
        sudo iwctl
        elif [[ $answer == "e" ]]; then
        echo "Ethernet configure"
    else
        echo "Invalid answer"
        exit 1
    fi
fi

echo "Current time is $(timedatectl)"

echo "Partitioning disk"
echo "Create EFI partition (if needed), root partition, swap partition"
echo "Type: EFI partition as FAT32, root partition as ext4, swap partition as swap"
fdisk -l
echo "Enter disk name (e.g. sda)"
read -r disk
fdisk /dev/$disk
root=""
root2="a"
while [[ $root != $root2 ]]; then
    echo "Enter root partition to format (e.g. sda1)"
    read -r root
    echo "Confirm root partition to format (e.g. sda1)"
    read -r root2
    if [[ $root != $root2 ]]; then
        echo "Partitions do not match"
    fi
done
mkfs.ext4 /dev/$root
swap=""
swap2="a"
while [[ $swap != $swap2 ]]; do
    echo "Enter swap partition to format (e.g. sda2)"
    read -r swap
    echo "Confirm swap partition to format (e.g. sda2)"
    read -r swap2
    if [[ $swap != $swap2 ]]; then
        echo "Partitions do not match"
    fi
done
mkswap /dev/$swap
echo "Format EFI partition [y/n]"
read -r answer
while [[ $answer != "y" && $answer != "n" ]]; do
    echo "Invalid answer"
    echo "Format EFI partition [y/n]"
    read -r answer
done
if [[ $answer == "y" ]]; then
    echo "Enter EFI partition to format (e.g. sda3)"
    read -r efi
    mkfs.fat -F 32 /dev/$efi
fi

echo "Mounting partitions"
mount /dev/$root /mnt
swapon /dev/$swap

echo "Installing base system"
sudo pacstrap -K /mnt base base-devel linux linux-firmware nano sudo

echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "Chrooting into new system"
arch-chroot /mnt

echo "Setting up timezone"
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

echo "Setting up locale"
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf

echo "Setting up hostname"
echo "Enter hostname: "
read -r hostname
echo "$hostname" >> /etc/hostname

echo "Set up root account password"
passwd

echo "Installing GRUB"
sudo pacman -S grub
mount /mnt/$efi
grub-install --target=x86_64-efi --efi-directory=/mnt/$efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
umount /mnt/$efi

echo "Installing microcode"
if [[ $(lscpu | grep "Vendor ID: GenuineIntel") ]]; then
    sudo pacman -S intel-ucode
    grub-mkconfig -o /boot/grub/grub.cfg
    elif [[ $(lscpu | grep "Vendor ID: AuthenticAMD") ]]; then
    sudo pacman -S amd-ucode
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "Installing git"
sudo pacman -S git

echo "Unmounting partitions"
umount -R /mnt

echo "Reboot system to complete installation"