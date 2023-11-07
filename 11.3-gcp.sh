#!/bin/bash

################################################################################
# 11.2 - APT - GOOGLE CLOUD
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

# Add Google Cloud SDK repository
add_repository "google-cloud-sdk" "https://packages.cloud.google.com/apt/doc/apt-key.gpg" "https://packages.cloud.google.com/apt cloud-sdk main" "$(dpkg --print-architecture)"

sudo apt update

sudo apt install gcloud -y