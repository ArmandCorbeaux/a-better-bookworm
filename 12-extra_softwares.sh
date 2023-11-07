#!/bin/bash

################################################################################
# 12 - SYSTEM - GET SOME EXTRA SOFTWARES
################################################################################

# Create a temporary directory for deb files

TEMP_DIR=$(mktemp -d)

# Download deb files
declare -A deb_urls=(
    ["Google_Chrome"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    ["Hyper_Terminal"]="https://releases.hyper.is/download/deb"
    ["Microsoft_Visual_Code"]="http://go.microsoft.com/fwlink/?LinkID=760868"
    ["Valve_Steam"]="https://media.steampowered.com/client/installer/steam.deb"
)

for app in "${!deb_urls[@]}"; do
    wget "${deb_urls[$app]}" -O "$TEMP_DIR/${app// /_}.deb"
done

# Install deb packages

sudo apt install $TEMP_DIR/*.deb -y

# Clean up the temporary directory

rm -Rf "$TEMP_DIR"
