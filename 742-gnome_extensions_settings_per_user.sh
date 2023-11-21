#!/bin/bash

################################################################################
# 742 - Custom Gnome Shell Extensions settings
################################################################################
#
# Job :     Personalize Gnome Shell experience
#
# Author :  Armand CORBEAUX
# Date :    2023-11-15
#
# Impact :  user
#
# Inputs :  SETTINGS
# Outputs : dconf
#
# More informations :
#           There are customized settings for installed extensions

EXTENSION_PATH="/org/gnome/shell/extensions"

# Dash to Dock settings
DASH_TO_DOCK_SETTINGS=(
  "hot-keys=false"
  "intellihide-mode='ALL_WINDOWS'"
  "running-indicator-style='DASHES'"
  "clock-action='focus-minimize-or-previews'"
  "dash-max-icon-size=64"
)

# Bing Wallpaper settings
BINGWALPAPER_SETTINGS=(
  "delete-previous=true"
  "selected-image='current'"
)

# Tiling Assistant settings
TILING_ASSISTANT_SETTINGS=(
  "restore-window='@as []'"
  "tile-bottom-half='@as []'"
  "tile-topleft-quarter='@as []'"
  "tile-topright-quarter='@as []'"
  "tile-bottomleft-quarter='@as []'"
  "tile-bottomright-quarter='@as []'"
  "tile-top-half='@as []'"
  "tile-left-half='@as []'"
  "tile-right-half='@as []'"
  "tile-maximize='@as []'"
)

# Function to apply settings for an extension
apply_settings() {
  local extension=$1
  local settings_array=$2

  for setting in "${settings_array[@]}"; do
    key="${setting%%=*}"  # Extracts the part before the equal sign
    value="${setting#*=}"  # Extracts the part after the equal sign
    dconf write "$EXTENSION_PATH/$extension/$key" "$value"
  done
}


# Apply settings for each extension
apply_settings "dash-to-dock" "${DASH_TO_DOCK_SETTINGS[@]}"
apply_settings "bingwallpaper" "${BINGWALPAPER_SETTINGS[@]}"
apply_settings "tiling-assistant" "${TILING_ASSISTANT_SETTINGS[@]}"

# Apply changes
dconf update