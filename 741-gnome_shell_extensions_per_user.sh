#!/bin/bash

################################################################################
# 741 - Gnome Shell Extensions
################################################################################
#
# Job :     Install Gnome Shell Extensions to imrove Gnome DEsktop experience
#
# Author :  Armand CORBEAUX
# Date :    2023-11-14
#
# Impact :  user
#
# Inputs :  EXTENSION_URLS
# Outputs : $HOME/.local/share/gnome-shell/extensions
#
# More informations :
#           Tiling Assistant :  add modern window tiling engine, disable default gnome one
#           Dash-to-Dock :      dock for the gnome shell
#           Bing Wallpaper :    apply daily Bing wallpaper on the desktop
#           Caffeine :          disable screensaver and autosuspend
#           AppIndicator :      tray icon support for Gnome Shell
#
#           Extensiosn can be installed system-wide, but users would be unable to update them

# gnome-shell-extension URLs
EXTENSION_URLS=(
  "https://extensions.gnome.org/extension-data/tiling-assistantleleat-on-github.v45.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/dash-to-dockmicxgx.gmail.com.v84.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/BingWallpaperineffable-gmail.com.v45.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/caffeinepatapon.info.v51.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v53.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/onedrivediegomerida.com.v11.shell-extension.zip"
)

sudo apt update &> /dev/null
# librabry needed to access Bing Wallpaper exntension's settings
sudo apt install gir1.2-soup-2.4 -y &> /dev/null

# Directory to store temporary files
tmp_dir=$(mktemp -d)

# Loop through each extension URL
for url in "${EXTENSION_URLS[@]}"; do
  
  # Download the extension
  wget "$url" -P "$tmp_dir"
  
  # Extract the extension
  extension_dir=$(unzip -q -d "$tmp_dir" "$tmp_dir/$(basename "$url")" | grep -oP 'creating: \K[^/]+')

  # Extract UUID from metadata.json
  uuid=$(jq -r .uuid "$tmp_dir/$extension_dir/metadata.json")
  
  # Rename the extension folder with UUID
  new_extension_dir="/usr/share/gnome-shell/extensions/$uuid"

  sudo mkdir -p "$new_extension_dir"
  sudo mv "$tmp_dir/$extension_dir"/* "$new_extension_dir"
  # Set permissions
  sudo chmod -R 755 "$new_extension_dir"
done

# Clean up temporary files
rm -r "$tmp_dir"