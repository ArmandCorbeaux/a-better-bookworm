#!/bin/bash

################################################################################
# 16 - Get Latest Proton-GE relase and install it in steam folder
################################################################################

# Define the GitHub repository and API URL
REPO_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"

# Fetch the latest release URL
RELEASE_URL=$(curl -s $REPO_URL | grep -o "https://.*\.tar\.gz" | head -n 1)

# Extract the release filename
RELEASE_FILENAME=$(basename "$RELEASE_URL")
RELEASE_NAME=$(echo $RELEASE_FILENAME | cut -d '.' -f 1)
dir_path="$HOME/.local/share/Steam/compatibilitytools.d/"
echo $RELEASE_NAME
# Check if the folder exists
if [ -d "$dir_path$RELEASE_NAME" ]; then
    echo "The folder $RELEASE_NAME already exists in $dir_path. Skipping installation."
else

    # Create a temporary directory
    TEMP_DIR=$(mktemp -d)

    # Download the release
    curl -L -o "$TEMP_DIR/$RELEASE_FILENAME" "$RELEASE_URL"

    # Extract the release
    tar -xzvf "$TEMP_DIR/$RELEASE_FILENAME" -C "$TEMP_DIR" &>/dev/null
    rm "$TEMP_DIR/$RELEASE_FILENAME"

    # Copy the uncompressed folder to the desired location
    mkdir -p "$dir_path"
    cp -r "$TEMP_DIR/"* $dir_path

    # Clean up temporary files and directories
    rm -Rf "$TEMP_DIR"
    
    echo "Latest release of Proton-GE has been installed."
fi