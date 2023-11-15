#!/bin/bash

################################################################################
# 801 - GOOGLE CLOUD CLI
################################################################################
#
# Job :     Install Google Cloud CLI tools
#
# Author :  Armand CORBEAUX
# Date :    2023-11-08
#
# Impact :  system
#
# Inputs :  GCP_REPOSITORY_URL, GCP_REPOSITORY_KEY,
#           DISTRIBUTION_KEYRING_PATH, DISTRIBUTION_SOURCES_LIST_PATH
# Outputs : apt
#
# More informations :
#           https://cloud.google.com/sdk/docs/install

REPOSITORY_URL="https://packages.cloud.google.com/apt cloud-sdk main"
REPOSITORY_KEY="https://packages.cloud.google.com/apt/doc/apt-key.gpg"
DISTRIBUTION_KEYRING_PATH="/usr/share/keyrings"
DISTRIBUTION_SOURCES_LIST_PATH="/etc/apt/sources.list.d"

# Function to add a repository
add_repository() {
    echo "Adding $1 repository"

    key_url=$2
    repository_url=$3
    keyring_path="$DISTRIBUTION_KEYRING_PATH/$1.gpg"
    archs=$4

    curl -fsSL "$key_url" | sudo gpg --dearmor -o "$keyring_path"

    echo "deb [arch=$archs signed-by=$keyring_path] $repository_url" | sudo tee "$DISTRIBUTION_SOURCES_LIST_PATH/$1.list"
}

# Add Google Cloud SDK repository
add_repository "google-cloud-sdk" "$REPOSITORY_KEY" "$REPOSITORY_URL" "$(dpkg --print-architecture)"

# Update packages list
sudo apt-get update > /dev/null

sudo apt-get install gcloud -y