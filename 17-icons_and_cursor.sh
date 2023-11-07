#!/bin/bash

################################################################################
# 17 - Install MoreWaita and Bibata Amber Cursor
################################################################################

# MoreWaita icon theme
git clone https://github.com/somepaulo/MoreWaita.git
cd MoreWaita
sudo ./install.sh
cd ..
rm -Rf MoreWaita

# Bibata cursor theme

# Fetch the latest release version from GitHub
latest_version=$(curl -s "https://api.github.com/repos/ful1e5/Bibata_Cursor/releases/latest" | jq -r ".tag_name")
if [ -z "$latest_version" ]; then
    echo "Failed to retrieve the latest version from GitHub."
    exit 1
fi

download_url="https://github.com/ful1e5/Bibata_Cursor/releases/download/${latest_version}/Bibata-Modern-Amber.tar.xz"

# Create a temporary directory for downloading and extracting the file
TEMP_DIR=$(mktemp -d)

# Download the file
echo "Downloading Bibata-Modern-Amber.tar.xz..."
curl -sL -o "$TEMP_DIR/Bibata-Modern-Amber.tar.xz" "$download_url"

# Uncompress the file
echo "Extracting Bibata-Modern-Amber.tar.xz..."
tar -xJf "$TEMP_DIR/Bibata-Modern-Amber.tar.xz" -C "$TEMP_DIR"

# Copy the folder to /usr/share/icons/
echo "Copying Bibata-Modern-Amber to /usr/share/icons/..."
sudo cp -r "$TEMP_DIR/Bibata-Modern-Amber" /usr/share/icons/

# Clean up the temporary directory
rm -Rf "$TEMP_DIR"

echo "Bibata-Modern-Amber has been copied to /usr/share/icons/"
