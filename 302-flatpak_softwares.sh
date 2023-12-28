#!/bin/bash

################################################################################
# 302 - FLATPAK - ADD SOFTWARES
################################################################################
#
# Job :     Install some useful applications
#
# Author :  Armand CORBEAUX
# Date :    2023-11-08
#
# Impact :  system wide
#
# Inputs :  FLATHUB_APPLICATION_LIST
# Outputs : flatpak
#
# More informations :
#           Evince :            documents viewer
#           Loupe :             pictures viewer (since Gnome 45)
#           Font Viewer :       previews fonts per name
#           Mission Center :    monitors system resources usages
#           Extension Manager : manages Gnome Shell Extensions

# List of Flatpak applications to install
FLATHUB_APPLICATION_LIST=(
  "com.mattjakeman.ExtensionManager"  # gnome-shell-extension-manager
  "io.missioncenter.MissionCenter"    # detailed resource monitoring
  "org.gnome.Evince"                  # document viewer
  "org.gnome.Loupe"                   # image viewer
  "org.gnome.font-viewer"             # font viewer
  "org.gnome.Boxes"                   # Virtual Machines manager
)

# Iterate through the applications and install them
for flathub_app in "${FLATHUB_APPLICATION_LIST[@]}"; do
  flatpak install "$flathub_app" -y
done
