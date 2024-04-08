#!/bin/bash

################################################################################
# 721 - Install Bibata Modern Amber cursor theme
################################################################################
#
# Job :     Install cursor pack
#
# Author :  Armand CORBEAUX
# Date :    2023-11-14
#
# Impact :  system wide
#
# Inputs :  BIBATA_GITHUB_URL, BIBATA_DOWNLOAD_URL,
#           BIBATA_ARCHIVE_NAME, BIBATA_ARCHIVE_EXTENSION,
# Outputs : SYSTEM_THEME_FOLDER
#
# More informations :
#           https://github.com/ful1e5/Bibata_Cursor
#           compact, and material designed cursor set that aims to improve the cursor experience for user

BIBATA_GITHUB_URL="https://api.github.com/repos/ful1e5/Bibata_Cursor/releases/latest"
BIBATA_DOWNLOAD_URL="https://github.com/ful1e5/Bibata_Cursor/releases/download"
BIBATA_ARCHIVE_NAME="Bibata-Modern-Amber"
BIBATA_ARCHIVE_EXTENSION=".tar.xz"
SYSTEM_THEME_FOLDER="/usr/share/icons/"

# Fetch the latest release version from GitHub
latest_version=$(curl -s $BIBATA_GITHUB_URL | jq -r ".tag_name")
if [ -z "$latest_version" ]; then
    echo "Failed to retrieve the latest version from GitHub."
    exit 1
fi

download_url="$BIBATA_DOWNLOAD_URL/${latest_version}/$BIBATA_ARCHIVE_NAME$BIBATA_ARCHIVE_EXTENSION"

# Create a temporary directory for downloading and extracting the file
temp_dir=$(mktemp -d)

# Download the file
echo "Downloading $BIBATA_ARCHIVE_NAME$BIBATA_ARCHIVE_EXTENSION..."
curl -sL -o "$temp_dir/$BIBATA_ARCHIVE_NAME$BIBATA_ARCHIVE_EXTENSION" "$download_url"

# Uncompress the file
echo "Extracting $BIBATA_ARCHIVE_NAME$BIBATA_ARCHIVE_EXTENSION..."
tar -xJf "$temp_dir/$BIBATA_ARCHIVE_NAME$BIBATA_ARCHIVE_EXTENSION" -C "$temp_dir"

# Copy the folder to /usr/share/icons/
echo "Copying $BIBATA_ARCHIVE_NAME to $SYSTEM_THEME_FOLDER..."
sudo cp -r "$temp_dir/$BIBATA_ARCHIVE_NAME" $SYSTEM_THEME_FOLDER

# Clean up the temporary directory
rm -Rf "$temp_dir"

echo "$BIBATA_ARCHIVE_NAME has been copied to $SYSTEM_THEME_FOLDER"
