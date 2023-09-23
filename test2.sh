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
# APT - SOURCES.LIST - ADD CONTRIB AND NON-FREE ENTRIES
################################################################################

# Create a new sources.list.tmp file to store the modified contents
sudo cp /etc/apt/sources.list /etc/apt/sources.list.tmp

# Flag to track if modifications are made
sources_list_modifications_made=false

# Iterate over the lines in the original sources.list file
while IFS= read -r line; do

  # If the line starts with deb or deb-src
  if [[ $line =~ ^deb.* ]]; then

    # Check if contrib non-free is already in the line
    if [[ ! $line =~ "contrib non-free" ]]; then

      # Add contrib non-free to the line
      modified_line="$line contrib non-free"

      # Replace the original line with the modified line in the temporary file
      sudo sed -i "s|$line|$modified_line|" /etc/apt/sources.list.tmp
      # Set the modifications flag to true
      sources_list_modifications_made=true
    fi

  fi

done < /etc/apt/sources.list

if [ "$sources_list_modifications_made" = true ]; then
  echo "'contrib non-free' entries added in /etc/apt/sources.list"
  # Replace the original sources.list file with the modified temporary file
  sudo mv /etc/apt/sources.list.tmp /etc/apt/sources.list
else
  sudo rm /etc/apt/sources.list.tmp
fi
