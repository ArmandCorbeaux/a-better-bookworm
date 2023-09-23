#!/usr/bin/env bash
#
# Post-installation script for a debian 12 bookworm minimal install
# Must have :
# - user with sudo rights
# - system installed on a btrfs partition

################################################################################
# CHECK OS ENVIRONMENT
################################################################################

lsb_release_path=$(which lsb_release 2> /dev/null)
dist_name=$(lsb_release -si)
dist_version=$(lsb_release -sr)
dist_codename=$(lsb_release -sc)

if [[ "$dist_name" != "Debian" ]] || [[ "$dist_version" != "12" ]]; then
    echo "Sorry. This script is only for Debian 12 Bookworm"
    exit 1
fi

# Check if the user has sudo privileges
if ! sudo -v; then
    echo "This script requires sudo privileges. Exiting."
    exit 1
fi

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run as root. Please run it as a regular user with sudo."
    exit 1
fi

################################################################################
# APT - ADD EXTRA REPOSITORIES
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

# Add OneDrive Linux repository
add_repository "onedrive" "https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/Release.key" "https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/ ./" "$(dpkg --print-architecture)"

# Add Docker repository
add_repository "docker" "https://download.docker.com/linux/debian/gpg" "https://download.docker.com/linux/debian $dist_codename stable" "$(dpkg --print-architecture)"

# Add Google Cloud SDK repository
add_repository "google-cloud-sdk" "https://packages.cloud.google.com/apt/doc/apt-key.gpg" "https://packages.cloud.google.com/apt cloud-sdk main" "$(dpkg --print-architecture)"

# Add Steam repository
add_repository "steam" "https://repo.steampowered.com/steam/archive/stable/steam.gpg" "https://repo.steampowered.com/steam/ stable steam" "amd64,i368"

sudo dpkg --add-architecture i386

# update the apt list
sudo apt update

