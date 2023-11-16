#!/bin/bash

################################################################################
# 401 - APT - DOCKER DESKTOP
################################################################################
#
# Job :     Install Docker-Desktop
#
# Author :  Armand CORBEAUX
# Date :    2023-11-08
#
# Impact :  system
#
# Inputs :  DOCKER_REPOSITORY_URL, DOCKER_REPOSITORY_KEY,
#           DISTRIBUTION_KEYRING_PATH, DISTRIBUTION_SOURCES_LIST_PATH,
#           DISTRIBUTION_SYSTEM_DESKTOP_SHORTCUT
# Outputs : Docker-Desktop
#
# More informations :
#           https://docs.docker.com/desktop/install/debian/
#
# Bugs :
#           if Docker-Desktop is already running, and user uses desktop shortcut to access it,
#           the service crashs and must be relaunch using "systemctl --user restart docker-desktop"
#           To fix this issue, the desktop shortcut is hidden.

# Get distribution codename
dist_codename=$(lsb_release -sc)

# Set Variables
REPOSITORY_URL="https://download.docker.com/linux/debian $dist_codename stable"
REPOSITORY_KEY="https://download.docker.com/linux/debian/gpg"
DISTRIBUTION_KEYRING_PATH="/usr/share/keyrings"
DISTRIBUTION_SOURCES_LIST_PATH="/etc/apt/sources.list.d"

# The shortcut to edit
FILE_PATH="/usr/share/applications/docker-desktop.desktop"

# Function to extract the latest Docker Desktop deb package URL
get_latest_docker_url() {
    local docker_url=$(curl -sL "https://docs.docker.com/desktop/install/debian/" | grep -oP 'https://desktop.docker.com/linux/main/amd64/docker-desktop-\d+\.\d+\.\d+-amd64.deb' | head -n 1)
}

# Define deb_urls files
declare -A DEB_URLS=(
    ["Docker_Desktop"]=$(get_latest_docker_url)
)

# Function to add repository
add_repository() {
    echo "Adding $1 repository"

    key_url=$2
    repository_url=$3
    keyring_path="$DISTRIBUTION_KEYRING_PATH/$1.gpg"
    archs=$4

    curl -fsSL "$key_url" | sudo gpg --dearmor -o "$keyring_path"

    echo "deb [arch=$archs signed-by=$keyring_path] $repository_url" | sudo tee "$DISTRIBUTION_SOURCES_LIST_PATH/$1.list"
}

# Add repository
add_repository "docker" "$REPOSITORY_KEY" "$REPOSITORY_URL" "$(dpkg --print-architecture)"

# Update packages list
sudo apt-get update > /dev/null

# Create a temporary directory for deb files
temp_dir=$(mktemp -d)

# Download deb_urls files
for app in "${!DEB_URLS[@]}"; do
    wget "${DEB_URLS[$app]}" -O "$temp_dir/${app// /_}.deb" -q --show-progress
done

# Install deb packages
sudo apt-get install $temp_dir/*.deb -y &> /dev/null

# Clean up the temporary directory
rm -Rf "$temp_dir"

# Hide docker-desktop icon
line_to_hide_desktop_icon="NoDisplay=true"

# Hide Docker-Desktop shortcut if it's not already done
if ! grep -q "NoDisplay=true" "$FILE_PATH"; then
    echo "$line_to_hide_desktop_icon" | sudo tee -a "$FILE_PATH" &> /dev/null
fi
