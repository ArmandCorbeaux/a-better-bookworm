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
# APT - SOURCES.LIST - ADD BACKPORTS REPOSITORY
################################################################################

# Check if backports entry already exists in sources.list
if sudo grep -q "$dist_codename-backports" /etc/apt/sources.list; then
    echo "Backports repository entry already exists. Nothing to do."
else
    # Add the backports repository entry to sources.list
    echo "Adding backports repository entry..."
    echo "deb http://deb.debian.org/debian $dist_codename-backports main non-free-firmware" | sudo tee -a /etc/apt/sources.list > /dev/null
    echo "deb-src http://deb.debian.org/debian $dist_codename-backports main non-free-firmware" | sudo tee -a /etc/apt/sources.list > /dev/null
    echo "Backports repository entry added."
fi
