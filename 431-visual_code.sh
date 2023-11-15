#!/bin/bash

################################################################################
# 431 - VISUAL CODE
################################################################################
#
# Job :     Install Visual Code
#
# Author :  Armand CORBEAUX
# Date :    2023-11-11
#
# Impact :  system
#
# Inputs :  DEB_URLS
# Outputs : apt
#
# More informations :
#           https://code.visualstudio.com/download

# Create a temporary directory for deb files
temp_dir=$(mktemp -d)

# Define the associative array of app names and their corresponding URLs
declare -A DEB_URLS=(
    ["Microsoft_Visual_Code"]="http://go.microsoft.com/fwlink/?LinkID=760868"
)

# Download deb files
for app in "${!DEB_URLS[@]}"; do
    wget "${DEB_URLS[$app]}" -O "$temp_dir/${app// /_}.deb"
done

# Install deb packages
sudo apt-get install $temp_dir/*.deb -y

# Clean up the temporary directory
rm -Rf "$temp_dir"
