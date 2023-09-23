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
# SYSTEM - GET SOME EXTRA SOFTWARES
################################################################################
# Create a temporary directory for deb files
mkdir -p ./temp_deb
touch ./temp_deb/safely_delete_this_directory

# Function to extract the latest Docker Desktop deb package URL
get_latest_docker_url() {
    local docker_url=$(curl -sL "https://docs.docker.com/desktop/install/debian/" | grep -oP 'https://desktop.docker.com/linux/main/amd64/docker-desktop-\d+\.\d+\.\d+-amd64.deb' | head -n 1)
    echo "$docker_url"
}

# Download deb files
declare -A deb_urls=(
    ["Google_Chrome"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    ["Hyper_Terminal"]="https://releases.hyper.is/download/deb"
    ["Microsoft_Visual_Code"]="http://go.microsoft.com/fwlink/?LinkID=760868"
    ["Valve_Steam"]="https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb"
    ["Docker_Desktop"]=$(get_latest_docker_url)
)

for app in "${!deb_urls[@]}"; do
    wget "${deb_urls[$app]}" -O "./temp_deb/${app// /_}.deb"
done

# Install deb packages
sudo apt install ./temp_deb/*.deb

# Clean up the temporary directory
rm -Rf ./temp_deb

