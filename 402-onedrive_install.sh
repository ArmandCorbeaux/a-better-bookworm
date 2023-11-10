#!/bin/bash

################################################################################
# 402 - APT - ONE DRIVE INSTALL
################################################################################
#
# Job :     Install OneDrive
#
# Author :  Armand CORBEAUX
# Date :    2023-11-08
#
# Impact :  system
#
# Inputs :  ONEDRIVE_REPOSITORY_URL, ONEDRIVE_REPOSITORY_KEY,
#           DISTRIBUTION_KEYRING_PATH, DISTRIBUTION_SOURCES_LIST_PATH
# Outputs : apt
#
# More informations :
#           https://github.com/abraunegg/onedrive

REPOSITORY_URL="https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/ ./"
REPOSITORY_KEY="https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/Release.key"
DISTRIBUTION_KEYRING_PATH="/usr/share/keyrings"
DISTRIBUTION_SOURCES_LIST_PATH="/etc/apt/sources.list.d"

# Function to add a repository
add_repository() {

    key_url=$2
    repository_url=$3
    keyring_path="$DISTRIBUTION_KEYRING_PATH/$1.gpg"
    archs=$4

    echo "Adding $1 repository"

    curl -fsSL "$key_url" | sudo gpg --dearmor -o "$keyring_path"

    echo "deb [arch=$archs signed-by=$keyring_path] $repository_url" | sudo tee "$DISTRIBUTION_SOURCES_LIST_PATH/$1.list"
}

# Add OneDrive Linux repository
add_repository "onedrive" "$REPOSITORY_KEY" "$REPOSITORY_URL" "$(dpkg --print-architecture)"

# Update packages list
sudo apt-get update > /dev/null

# Install onedrive
sudo apt-get install onedrive -y