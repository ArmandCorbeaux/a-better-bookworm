#!/bin/bash

################################################################################
# 12 - SYSTEM - GET SOME EXTRA SOFTWARES
################################################################################

# Create a temporary directory for deb files
TEMP_DIR=$(mktemp -d)

# Define the associative array of app names and their corresponding URLs
declare -A deb_urls=(
    ["Microsoft_Visual_Code"]="http://go.microsoft.com/fwlink/?LinkID=760868"
    ["Valve_Steam"]="https://media.steampowered.com/client/installer/steam.deb"
)

# Download deb files
for app in "${!deb_urls[@]}"; do
    wget "${deb_urls[$app]}" -O "$TEMP_DIR/${app// /_}.deb"
done

# Install deb packages
sudo apt-get install $TEMP_DIR/*.deb -y

# Clean up the temporary directory

rm -Rf "$TEMP_DIR"
