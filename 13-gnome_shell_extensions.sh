#!/bin/bash

################################################################################
# 13 - GNOME - INSTALL GNOME-SHELL EXTENSIONS
################################################################################

# gnome-shell-extension URLs

extension_urls=(
  "https://extensions.gnome.org/extension-data/tiling-assistantleleat-on-github.v45.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/dash-to-dockmicxgx.gmail.com.v84.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/BingWallpaperineffable-gmail.com.v45.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/caffeinepatapon.info.v51.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v53.shell-extension.zip"
)

# Install each extension
for url in "${extension_urls[@]}"; do
  gnome-extensions install "$url"
done

# enable extensions
extension_uuid=(
  "BingWallpaper@ineffable-gmail.com"
  "dash-to-dock@micxgx.gmail.com"
  "appindicatorsupport@rgcjonas.gmail.com"
  "tiling-assistant@leleat-on-github"
  "caffeine@patapon.info"
)

for uuid in "${extension_uuid[@]}"; do
  gnome-extensions enable "$uuid"
done

# librabry needed to access Bing Wallpaper exntension's settings
sudo apt update
sudo apt install gir1.2-soup-2.4 -y
