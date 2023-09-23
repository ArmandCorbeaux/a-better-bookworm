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
# APT - SOURCES.LIST - DISABLE DEB-SRC LINES
################################################################################

# Temp file to store modified lines
temp_file=$(mktemp)
sources_list_modifications_made=false

# Read the sources.list file line by line
while IFS= read -r line; do
  # If the line starts with deb-src
  if [[ $line =~ ^deb-src.* ]]; then
    # Add # to the beginning of the line
    echo "#$line" >> "$temp_file"
    sources_list_modifications_made=true
  else
    echo "$line" >> "$temp_file"
  fi
done < "/etc/apt/sources.list"

if [ "$sources_list_modifications_made" = true ]; then
  # Replace the original file with the modified content
  sudo mv "$temp_file" "/etc/apt/sources.list"
  echo "deb-src lines have been disabled in the sources.list file."
else
  # No changes were made
  rm "$temp_file"
  echo "No changes were made to the sources.list file."
fi


