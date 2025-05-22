#!/bin/sh


echo "Adding multilib to pacman.conf"
# Check if [multilib] section exists
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    echo "Added multilib repository."
else
    echo "Multilib repository already present."
fi

echo "Updating pacman database"
pacman -Sy --needed --noconfirm

echo "Installing pacman packages"
pacman -S --needed --noconfirm $(< packages.txt)

echo "adding new user"

# Get user input
read -p "Enter username: " username
read -s -p "Enter password for $username: " password

# Create the user with bash shell
useradd -m -s /bin/bash "$username"
echo "$username:$password" | chpasswd

# Add user to wheel group
usermod -aG wheel "$username"


echo "Enabling wheel group in sudoers"
# Check if line is already enabled
if ! grep -qE '^%wheel ALL=\(ALL:ALL\) ALL' /etc/sudoers; then
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
    echo "Enabled wheel group in sudoers."
else
    echo "Wheel group already enabled in sudoers."
fi

echo "User '$username' created with sudo access."
echo "First part is done. Now installing config files"

echo "Copying .config directory"
su "$username" -c 'cp -r .config ~/'

echo "Copying .local directory"
su "$username" -c 'cp -r .local ~/'

echo "Copying .bashrc and .xinitrc directory"
su "$username" -c 'cp .bashrc .xinitrc ~/'

echo "Updating desktop database"
su "$username" -c 'update-desktop-database ~/.local/share/applications/'

echo "installing yay (AUR helper)"
su "$username" -c "sh yay_install.sh"

echo "installing aur packages"
su "$username" -c 'yay -S --needed --noconfirm $(< yay_packages.txt)'

echo "Rofi font setup"
su "$username" -c 'sh rofi_font_setup.sh'

echo "grub setup"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
