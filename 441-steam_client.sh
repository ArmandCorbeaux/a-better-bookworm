#!/bin/bash

################################################################################
# 441 - STEAM CLIENT
################################################################################
#
# Job :     Install Steam Client
#
# Author :  Armand CORBEAUX
# Date :    2023-11-13
#
# Impact :  system
#
# Inputs :  DEB_URLS
# Outputs : apt
#
# More informations :
#           https://store.steampowered.com/about/
#

# Create a temporary directory for deb files
temp_dir=$(mktemp -d)

# Define the associative array of app names and their corresponding URLs
declare -A DEB_URLS=(
    ["Valve_Steam"]="https://media.steampowered.com/client/installer/steam.deb"
)

# Download deb files
for app in "${!DEB_URLS[@]}"; do
    wget "${DEB_URLS[$app]}" -O "$temp_dir/${app// /_}.deb"
done

# Install deb packages
sudo apt-get install $temp_dir/*.deb -y

# Clean up the temporary directory
rm -Rf "$temp_dir"
