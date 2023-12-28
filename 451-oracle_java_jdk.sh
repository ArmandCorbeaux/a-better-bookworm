#!/bin/bash

################################################################################
# 451 - Oracle Java JDK
################################################################################
#
# Job :     Install Oracle Java JDK
#
# Author :  Armand CORBEAUX
# Date :    2023-11-15
#
# Impact :  system wide
#
# Inputs :  ORACLE_DOWNLOAD_PAGE
# Outputs : apt
#
# More informations :
#           https://www.oracle.com/java/technologies/downloads/

ORACLE_DOWNLOAD_PAGE="https://www.oracle.com/java/technologies/downloads/"

# Get the latest debian package in page content
page=$(wget -O- -q --no-check-certificate $ORACLE_DOWNLOAD_PAGE)

# Extract the URL of the latest deb package
latest_deb_url=$(echo "$page" | grep -oP '[^"]*.deb' | head -n 1)

# Check if latest_deb_url is empty
if [ -z "$latest_deb_url" ]; then
    echo "Error: Unable to retrieve the latest deb package URL. Exiting script."
    exit 1
fi

# Create a temporary directory for deb files
temp_dir=$(mktemp -d)

# Define the associative array of app names and their corresponding URLs
declare -A DEB_URLS=(
    ["Oracle_Java_JDK"]="$latest_deb_url"
)

# Download deb files
for app in "${!DEB_URLS[@]}"; do
    wget "${DEB_URLS[$app]}" -O "$temp_dir/${app// /_}.deb" -q --show-progress
done

# Install deb packages
sudo apt-get install $temp_dir/*.deb -y &> /dev/null

# Clean up the temporary directory
rm -Rf "$temp_dir"