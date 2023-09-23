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
# ADD ZRAMSWAP AND DPHYS-SWAPFILE
################################################################################
echo "Install and configure swap spaces"
sudo apt -t $dist_codename-backports install zram-tools dphys-swapfile -y --quiet

# ZRAM - desired values
ALGO="zstd"
PERCENT=100
PRIORITY=100

# ZRAM - uncomment and modify the values
sudo sed -i "s/#\s*ALGO=.*/ALGO=\"$ALGO\"/" /etc/default/zramswap
sudo sed -i "s/#\s*PERCENT=.*/PERCENT=$PERCENT/" /etc/default/zramswap
sudo sed -i "s/#\s*PRIORITY=.*/PRIORITY=$PRIORITY/" /etc/default/zramswap

# DPHYS-SWAPFILE - configure
sudo sed -i 's/#CONF_MAXSWAP=2048/CONF_MAXSWAP=/g' /etc/dphys-swapfile

# Turn off the swap file
sudo dphys-swapfile swapoff

# Uninstall dphys-swapfile
sudo dphys-swapfile uninstall

# Set up dphys-swapfile with the default settings
sudo dphys-swapfile setup

# Turn on the swap file
sudo dphys-swapfile swapon

