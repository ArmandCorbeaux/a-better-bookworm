#!/bin/bash

################################################################################
# 10 - FLATPAK - ADD SOFTWARES
################################################################################
#
# Job :     Install some useful applications
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  current user
#
# Inputs :  FLATHUB_APPLICATION_LIST
# Outputs : flatpak
#
# More informations :
#   

# List of Flatpak applications to install
FLATHUB_APPLICATION_LIST=(
  "com.mattjakeman.ExtensionManager" # gnome-shell-extension-manager
  "io.missioncenter.MissionCenter" # detailed resource monitoring
  "org.gnome.Evince" # document viewer
  "org.gnome.Loupe" # image viewer
  "org.gnome.font-viewer" # font viewer
  "org.gnome.Firmware" # hardware firmware updater
)

# Iterate through the applications and install them
for flathub_app in "${FLATHUB_APPLICATION_LIST[@]}"; do
  flatpak install "$flathub_app" -y
done
