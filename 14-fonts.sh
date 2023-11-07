#!/bin/bash

################################################################################
# 14 - FONTS WITH LIGATURE SUPPORT - INSTALL
################################################################################

# URL of the GitHub releases page
GITHUB_URL="https://github.com/ryanoasis/nerd-fonts/releases"

# Fetch the HTML content of the GitHub releases page
HTML=$(curl -s "$GITHUB_URL")

# Extract the download link for the latest release
LATEST_RELEASE=$(echo "$HTML" | grep -o -m 1 -P 'https://github.com/ryanoasis/nerd-fonts/releases/download/v\d+\.\d+\.\d+/FiraCode\.zip')

# Download the font using curl
curl -L -o "FiraCode.zip" "$LATEST_RELEASE"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "FiraCode Nerd Font downloaded successfully."
else
  echo "Failed to download FiraCode Nerd Font."
fi

# Download Victor Mono Font with wget

wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip

# Now extract the fonts
unzip FiraCode.zip -d FiraCode
unzip VictorMonoAll.zip -d VictorMonoAll

# Move the fonts in the right place
mv VictorMonoAll/TTF VictorMono
sudo mv FiraCode /usr/share/fonts/truetype/
sudo mv VictorMono /usr/share/fonts/truetype/

# Clean up
rm -Rf FiraCode*
rm -Rf VictorMono*

# Add an emoji font
sudo apt update
sudo apt install fonts-noto-color-emoji -y
