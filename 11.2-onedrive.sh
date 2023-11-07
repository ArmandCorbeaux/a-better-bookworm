#!/bin/bash

################################################################################
# 11.2 - APT - ONE DRIVE
################################################################################

add_repository() {
    echo "Adding $1 repository"

    key_url=$2
    repository_url=$3
    keyring_path="/usr/share/keyrings/$1.gpg"
    archs=$4

    curl -fsSL "$key_url" | sudo gpg --dearmor -o "$keyring_path"

    echo "deb [arch=$archs signed-by=$keyring_path] $repository_url" | sudo tee "/etc/apt/sources.list.d/$1.list"
}

# Add OneDrive Linux repository
add_repository "onedrive" "https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/Release.key" "https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/ ./" "$(dpkg --print-architecture)"

sudo apt update

sudo apt install onedrive -y

# Add configuration to skip temporary files from sync
mkdir -p ~/.config/onedrive
echo "Remove a bunch of temporary files from sync with OneDrive client"
echo "skip_file = \"~*|.~*|*.tmp|*.swp|__*__|.venv|.vscode|log|logs\"" >> ~/.config/onedrive/config
