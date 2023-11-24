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
)

# Install each extension
for url in "${EXTENSION_URLS[@]}"; do
  sudo gnome-extensions install "$url"
done

# librabry needed to access Bing Wallpaper exntension's settings
sudo apt update &> /dev/null
sudo apt install gir1.2-soup-2.4 -y &> /dev/null
