#!/bin/bash

################################################################################
# 471 - WARP TERMINAL
################################################################################
#
# Job :     Install Warp Terminal
#
# Author :  Armand CORBEAUX
# Date :    2024-02-25
#
# Impact :  system wide
#
# Inputs :  DEB_URLS
# Outputs : apt
#
# More informations :
#           https://www.warp.dev/
#

# Create a temporary directory for deb files
temp_dir=$(mktemp -d)

# Define the associative array of app names and their corresponding URLs
declare -A DEB_URLS=(
    ["Warp_Terminak"]="https://app.warp.dev/get_warp?package=deb"
)

# Download deb files
for app in "${!DEB_URLS[@]}"; do
    wget "${DEB_URLS[$app]}" -O "$temp_dir/${app// /_}.deb" -q --show-progress
done

# Install deb packages
sudo apt-get install $temp_dir/*.deb -y &> /dev/null

# Clean up the temporary directory
rm -Rf "$temp_dir"
