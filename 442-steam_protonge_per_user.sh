#!/bin/bash

################################################################################
# 442 - Get Latest Proton-GE release
################################################################################
#
# Job :     Install Proton_GE
#
# Author :  Armand CORBEAUX
# Date :    2023-11-13
#
# Impact :  user
#
# Inputs :  REPO_URL
# Outputs : apt
#
# More informations :
#           https://github.com/GloriousEggroll/proton-ge-custom
#           
#           Proton-GE is a custom bluid of Valve's Proton.
#           It permits to enable FSR 1.0 support           

# Define the GitHub repository and API URL
REPO_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"

# Define the local directory  to store files
DIR_PATH="$HOME/.local/share/Steam/compatibilitytools.d"

# Fetch the latest release URL
release_url=$(curl -s $REPO_URL | grep -o "https://.*\.tar\.gz" | head -n 1)

# Extract the release filename
release_filename=$(basename "$release_url")
release_name=$(echo $release_filename | cut -d '.' -f 1)

# Check if the folder exists
if [ -d "$DIR_PATH/$release_name" ]; then

    echo "The folder $release_name already exists in $DIR_PATH. Skipping installation."

else

    # Create a temporary directory
    temp_dir=$(mktemp -d)

    # Download the latest release
    curl -L -o "$temp_dir/$release_filename" "$release_url" &> /dev/null

    # Extract the release
    tar -xzvf "$temp_dir/$release_filename" -C "$temp_dir" &>/dev/null

    # Remove the downloaded archive
    rm "$temp_dir/$release_filename"

    # Copy the uncompressed folder to the desired location
    mkdir -p "$DIR_PATH"
    cp -r "$temp_dir/"* $DIR_PATH

    # Clean up temporary files and directories
    rm -Rf "$temp_dir"
    
    echo "Latest release of Proton-GE has been installed."
    echo "To enable FSR, you can add “WINE_FULLSCREEN_FSR=1 %command%” to the launch options of each game in Steam"
    echo "A memento file has been added in your HOME"
    echo "To enable FSR, you have to add this command to the custom line launch options of each game in Steam :" >  "$HOME/memento_fsr_protonge_steam.txt" $> /dev/null
    echo “WINE_FULLSCREEN_FSR=1 %command%” >> "$HOME/memento_fsr_protonge_steam.txt" $> /dev/null
fi