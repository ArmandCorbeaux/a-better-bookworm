#!/bin/bash

################################################################################
# 701 - Specific fonts installation
################################################################################
#
# Job :     Install some specific Fonts
#
# Author :  Armand CORBEAUX
# Date :    2023-11-14
#
# Impact :  system
#
# Inputs :  NERD_FONTS_GITHUB_URL, VICTORMONO_URL, NOTO_FONT_APT, FONT_INSTALL_PATH
# Outputs : apt, FONT_INSTALL_PATH
#
# More informations :
#           FiraCode :    font with ligature support
#                         https://github.com/tonsky/FiraCode
#                         extended with Nerd Fonts variation
#                         https://www.nerdfonts.com/
#
#           VictorMono :  monospaced font with optional semi-connected cursive italics and programming symbol ligatures
#                         https://rubjo.github.io/victor-mono/
#
#           Noto Emoji :  font that has you covered for all your emoji needs,
#                         including support for the latest Unicode emoji specification.
#                         It has multiple weights and features thousands of emoji.
#                         https://github.com/googlefonts/noto-emoji

# URL of the GitHub releases page
NERD_FONTS_GITHUB_URL="https://github.com/ryanoasis/nerd-fonts/releases"
VICTORMONO_URL="https://rubjo.github.io/victor-mono/VictorMonoAll.zip"
NOTO_FONT_APT="fonts-noto-color-emoji"
FONT_INSTALL_PATH="/usr/share/fonts/truetype/"

# Fetch the HTML content of the GitHub releases page
html_content=$(curl -s "$NERD_FONTS_GITHUB_URL")

# Extract the download link for the latest release
latest_release=$(echo "$html_content" | grep -o -m 1 -P 'https://github.com/ryanoasis/nerd-fonts/releases/download/v\d+\.\d+\.\d+/FiraCode\.zip')

# Download the font using curl
curl -L -o "FiraCode.zip" "$latest_release"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "FiraCode Nerd Font downloaded successfully."
else
  echo "Failed to download FiraCode Nerd Font."
fi

# Download Victor Mono Font with wget
wget $VICTORMONO_URL  -q --show-progress

# Now extract the fonts
unzip FiraCode.zip -d FiraCode
unzip VictorMonoAll.zip -d VictorMonoAll

# Move the fonts in the right place
mv VictorMonoAll/TTF VictorMono
sudo mv FiraCode $FONT_INSTALL_PATH
sudo mv VictorMono $FONT_INSTALL_PATH

# Clean up
rm -Rf FiraCode*
rm -Rf VictorMono*

# Add an emoji font
sudo apt update &> /dev/null
sudo apt install $NOTO_FONT_APT -y &> /dev/null
