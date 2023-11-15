#!/bin/bash

################################################################################
# 731 - Custom Gnome Shell settings
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
#           To have a default system settings change, a way would be to change :
#           /usr/share/glib-2.0/schemas/
#           Which means to create a customized package of 'gsettings-desktop-schemas'

# Some custom Gnome settings which modify the desktop environment
SETTINGS=(
  "org.gnome.desktop.calendar show-weekdate true"
  "org.gnome.desktop.datetime automatic-timezone true"
  "org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Amber'"
  "org.gnome.desktop.interface icon-theme 'MoreWaita'"
  "org.gnome.desktop.interface clock-show-seconds true"
  "org.gnome.desktop.interface clock-show-weekday true"
  "org.gnome.desktop.interface enable-hot-corners false"
  "org.gnome.desktop.interface font-antialiasing 'rgba'"
  "org.gnome.desktop.interface font-hinting 'full'"
  "org.gnome.desktop.interface show-battery-percentage true"
  "org.gnome.desktop.interface font-name 'Cantarell 11'"
  "org.gnome.desktop.interface monospace-font-name 'FiraCode Nerd Font 11'"
  "org.gnome.desktop.peripherals.touchpad tap-to-click true"
  "org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true"
  "org.gnome.desktop.peripherals.mouse natural-scroll true"
  "org.gnome.desktop.peripherals.keyboard numlock-state true"
  "org.gnome.desktop.wm.preferences action-double-click-titlebar none"
  "org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'"
  "org.gnome.mutter center-new-windows true"
  "org.gnome.mutter edge-tiling true"
  "org.gnome.nautilus.icon-view default-zoom-level small"
  "org.gnome.nautilus.preferences show-hidden-files true"
  "org.gnome.shell.weather automatic-location true"
  "org.gnome.system.location enabled true"
  "org.gnome.software enable-repos-dialog false"
  "org.gnome.software show-ratings true"
  "org.gtk.Settings.FileChooser sort-directories-first true"
  "org.gtk.Settings.FileChooser show-hidden true"
  "org.gtk.Settings.FileChooser sort-order 'ascending'"
  "org.gtk.gtk4.Settings.FileChooser sort-directories-first true"
  "org.gtk.gtk4.Settings.FileChooser show-hidden true"
  "org.gtk.Settings.FileChooser sort-order 'ascending'"
)

# Loop through the settings and apply them using gsettings
# eval permits to not consider space as separated settings (needed for font lines)
for setting in "${SETTINGS[@]}"; do
  eval gsettings set $setting
done

# Purpose Flatpak apps first in Gnome-Software
dconf write /org/gnome/software/packaging-format-preference "['flatpak', 'deb']"
