#!/bin/sh

echo "Adding multilib to pacman"
echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | tee -a /etc/pacman.conf > /dev/null

echo "Updating pacman database"
pacman -Sy --needed --noconfirm

echo "Installing pacman packages"
pacman -S --needed --noconfirm $(< packages.txt)

echo "adding new user"

# Get user input
read -p "Enter username: " username
read -s -p "Enter password for $username: " password
echo

# Create the user with fish shell
useradd -m -s /bin/bash "$username"
echo "$username:$password" | chpasswd

# Add to groups
usermod -aG wheel "$username"

echo "Enabling wheel group in sudoers"
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

echo "User '$username' created with sudo access."
echo "First part is done. Now installing config files"

echo "Copying .config directory"
su "$username" -c 'cp -r .config ~/'

echo "Copying .local directory"
su "$username" -c 'cp -r .local ~/'

echo "Updating desktop database"
su "$username" -c 'update-desktop-database ~/.local/share/applications/'

sh yay_install.sh
su "$username" -c 'yay -S --needed --noconfirm $(< yay_packages.txt)'

echo "Rofi font setup"
su "$username" -c 'sh rofi_font_setup.sh'
