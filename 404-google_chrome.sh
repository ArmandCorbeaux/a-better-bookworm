#!/bin/bash

################################################################################
# 403 - GOOGLE CHROME
################################################################################
#
# Job :     Install Google Chrome and enable somes flags
#
# Author :  Armand CORBEAUX
# Date :    2023-11-09
#
# Impact :  system
#
# Inputs :  deb_urls, CHROME_FLAGS, FILE
# Outputs : apt, /usr/share/applications/google-chrome.desktop
#
# More informations :
#           https://www.google.com/chrome/?platform=linux           
#           CHROME_FLAGS aren't taken in account through /etc/environment.
#           Choice is to modify the system desktop shortcut to add chrome flags

# Define the new value for CHROME_FLAGS
CHROME_FLAGS="--ozone-platform=wayland --enable-features=UsePipeWire --enable-features=Vulkan"

# The shortcut to edit
FILE_PATH=/usr/share/applications/google-chrome.desktop

# URL to deb file
declare -A DEB_URLS=(
    ["Google_Chrome"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
)

# Create a temporary directory for deb files
temp_dir=$(mktemp -d)

# Download deb_urls files
for app in "${!DEB_URLS[@]}"; do
    wget "${DEB_URLS[$app]}" -O "$temp_dir/${app// /_}.deb"
done

# Install deb packages
sudo apt-get install $temp_dir/*.deb -y

# Clean up the temporary directory
rm -Rf "$temp_dir"

# Edit the Google Chrome desktop shortcut to add flags if not already in place
sudo sed -i "/^Exec=/ {/ $CHROME_FLAGS/! s/$/ $CHROME_FLAGS/}" $FILE_PATH > /dev/null
