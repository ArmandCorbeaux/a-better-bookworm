#!/bin/bash

################################################################################
# 999 - Custom Gnome Shortcut Organization settings
################################################################################
#
# Job :     Personalize Gnome Shortcut Organization
#
# Author :  Armand CORBEAUX
# Date :    2023-11-21
#
# Impact :  user
#
# Inputs :  dconf
# Outputs : dconf
#
# More informations :
#           To have a default system settings change, a way would be to change :
#           /usr/share/glib-2.0/schemas/
#           Which means to create a customized package of 'gsettings-desktop-schemas'

# Function to set icons
set_icons() {
    # Define icons as 'favorite', which are displayed in Dash-to-Dock
    dconf write /org/gnome/shell/favorite-apps "@as ['google-chrome.desktop', 'code.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop']"

    # Define icons in 'Utilities' folder
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/apps "@as ['org.gnome.Boxes.desktop', 'org.gnome.Evince.desktop', 'org.gnome.Loupe.desktop', 'org.gnome.baobab.desktop', 'org.gnome.font-viewer.desktop', 'org.gnome.Console.desktop', 'yelp.desktop', 'nm-connection-editor.desktop', 'im-config.desktop', 'software-properties-gtk.desktop', 'org.gnome.DiskUtility.desktop']"

    # Define the order of the icons in Overview
    dconf write /org/gnome/shell/app-picker-layout "[{ \
    'org.gnome.Software.desktop': <{'position': <0>}>, \
    'com.mattjakeman.ExtensionManager.desktop': <{'position': <1>}>, \
    'org.gnome.tweaks.desktop': <{'position': <2>}>, \
    'org.gnome.Settings.desktop': <{'position': <3>}>, \
    'Utilities': <{'position': <4>}>, \
    'io.missioncenter.MissionCenter.desktop': <{'position': <5>}>, \
    'steam.desktop': <{'position': <6>}>, \
    'minecraft-launcher.desktop': <{'position': <7>}>
    }]"
}

# Execute the lines twice
for _ in {1..2}; do
    set_icons
done
