#!/bin/bash

################################################################################
# 11.1 - APT - DOCKER DESKTOP
################################################################################

# Function to add a repository

add_repository() {
    echo "Adding $1 repository"

    key_url=$2
    repository_url=$3
    keyring_path="/usr/share/keyrings/$1.gpg"
    archs=$4

    curl -fsSL "$key_url" | sudo gpg --dearmor -o "$keyring_path"

    echo "deb [arch=$archs signed-by=$keyring_path] $repository_url" | sudo tee "/etc/apt/sources.list.d/$1.list"
}

# Add Docker repository
add_repository "docker" "https://download.docker.com/linux/debian/gpg" "https://download.docker.com/linux/debian $dist_codename stable" "$(dpkg --print-architecture)"

# update the apt list
sudo apt update

# Create a temporary directory for deb files

TEMP_DIR=$(mktemp -d)

# Function to extract the latest Docker Desktop deb package URL

get_latest_docker_url() {
    local docker_url=$(curl -sL "https://docs.docker.com/desktop/install/debian/" | grep -oP 'https://desktop.docker.com/linux/main/amd64/docker-desktop-\d+\.\d+\.\d+-amd64.deb' | head -n 1)
    echo "$docker_url"
}

# Download deb files
declare -A deb_urls=(
    ["Docker_Desktop"]=$(get_latest_docker_url)
)

for app in "${!deb_urls[@]}"; do
    wget "${deb_urls[$app]}" -O "$TEMP_DIR/${app// /_}.deb"
done

# Install deb packages

sudo apt install $TEMP_DIR/*.deb -y

# Clean up the temporary directory

rm -Rf "$TEMP_DIR"

# Enable Docker Services
systemctl --user enable docker-desktop

# hide docker-desktop icon as it crashs docker-desktop if u
file_path="/usr/share/applications/docker-desktop.desktop"
new_line="NoDisplay=true"

echo "$new_line" | sudo tee -a "$file_path"

