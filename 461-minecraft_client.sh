#!/bin/bash

################################################################################
# 461 - MINECRAFT LAUNCHER
################################################################################
#
# Job :     Install Minecraft Launcher
#
# Author :  Armand CORBEAUX
# Date :    2023-11-15
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
    ["Minecraft_Launcher"]="https://launcher.mojang.com/download/Minecraft.deb"
)

# Download deb files
for app in "${!DEB_URLS[@]}"; do
    wget "${DEB_URLS[$app]}" -O "$temp_dir/${app// /_}.deb" -q --show-progress
done

# Install deb packages
sudo apt-get install $temp_dir/*.deb -y &> /dev/null

# Clean up the temporary directory
rm -Rf "$temp_dir"
