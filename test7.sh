#!/usr/bin/env bash
#
# Post-installation script for a debian 12 bookworm minimal install
# Must have :
# - user with sudo rights
# - system installed on a btrfs partition

################################################################################
# CHECK OS ENVIRONMENT
################################################################################

lsb_release_path=$(which lsb_release 2> /dev/null)
dist_name=$(lsb_release -si)
dist_version=$(lsb_release -sr)
dist_codename=$(lsb_release -sc)

if [[ "$dist_name" != "Debian" ]] || [[ "$dist_version" != "12" ]]; then
    echo "Sorry. This script is only for Debian 12 Bookworm"
    exit 1
fi

# Check if the user has sudo privileges
if ! sudo -v; then
    echo "This script requires sudo privileges. Exiting."
    exit 1
fi

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run as root. Please run it as a regular user with sudo."
    exit 1
fi

################################################################################
# CUSTOMIZE BOOT
################################################################################
echo "Customize Boot Splash"

# install plymouth-theme and set theme to use OEM Bios Logo
sudo apt -t $dist_codename-backports plymouth-themes -y --quiet
sudo plymouth-set-default-theme -R bgrt
echo "Plymouth splash has been changed."

# Customize GRUB values
NEW_GRUB_TIMEOUT=0  # Immediatly load the kernel
NEW_GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=0"  # Show plymouth theme
NEW_GRUB_BACKGROUND=""  # No background
GRUB_PATH="/etc/default/grub"

# Change the GRUB_TIMEOUT value
sudo sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$NEW_GRUB_TIMEOUT/" $GRUB_PATH
# Change the GRUB_CMDLINE_LINUX_DEFAULT value
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_GRUB_CMDLINE_LINUX_DEFAULT\"/" $GRUB_PATH
# Change the GRUB_BACKGROUND value
sudo sed -i "s/GRUB_BACKGROUND=.*/GRUB_BACKGROUND=\"$NEW_GRUB_BACKGROUND\"/" $GRUB_PATH

sudo update-grub
echo "GRUB settings have been changed."

