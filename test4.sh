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
# CHANGE BTRFS FLAGS IN FSTAB
################################################################################

# Variable to track if changes were made
fstab_modifications_made=false

# Check each line in /etc/fstab
while IFS= read -r line; do
  if [[ "$line" == *"btrfs"* ]] && [[ "$line" == *"default"* ]]; then
    # Replace 'default' with 'ssd,discard=async,autodefrag,compress=zstd'
    updated_line=$(echo "$line" | sed 's/default/ssd,discard=async,autodefrag,compress=zstd,noatime/')
    echo "Replacing line: $line"
    echo "With: $updated_line"

    # Use sudo to update the file
    sudo sed -i "s|$line|$updated_line|" /etc/fstab

    # Set changes_made to true
    fstab_modifications_made=true
  fi
done < /etc/fstab

# Check if changes were made and echo appropriate message
if [ "$fstab_modifications_made" = true ]; then
  echo "Changes were made to /etc/fstab to tweak btrfs for electronic storage."
else
  echo "No changes were made to /etc/fstab."
fi
