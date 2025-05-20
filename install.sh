#!/bin/sh

echo "Adding multilib to pacman"
#echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null

echo "Updating pacman database"
#pacman -Sy --needed --noconfirm

echo "Installing pacman packages"
sudo pacman -S --needed --noconfirm $(< packages.txt)

echo "adding new user"

# Get user input
read -p "Enter username: " username
read -s -p "Enter password for $username: " password
echo

# Create the user with fish shell
useradd -m -s /usr/bin/fish "$username"
echo "$username:$password" | chpasswd

# Add to groups
usermod -aG wheel "$username"

echo "Enabling wheel group in sudoers"
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

echo "User '$username' created with fish shell and sudo access."

su $username

echo "Copying .config directory"
cp -r .config ~/

echo "Copying .local directory"
cp -r .local ~/

echo "Updating desktop database"
update-desktop-database ~/.local/share/applications/

sh yay_install.sh
yay -S --needed --noconfirm $(< yay_packages.txt)
