#!/bin/bash

################################################################################
# 18 - Custom Gnome 43 settings
################################################################################

# Some custom Gnome settings which modify the desktop environment
settings=(
  "org.gnome.desktop.calendar show-weekdate true"
  "org.gnome.desktop.datetime automatic-timezone true"
  "org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Amber'"
  "org.gnome.desktop.interface icon-theme 'MoreWaita'"
  "org.gnome.desktop.interface clock-show-seconds true"
  "org.gnome.desktop.interface clock-show-weekday true"
  "org.gnome.desktop.interface enable-hot-corners false"
  "org.gnome.desktop.interface font-antialiasing 'grayscale'"
  "org.gnome.desktop.interface font-hinting 'slight'"
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
)

# Loop through the settings and apply them using gsettings
for setting in "${settings[@]}"; do
  gsettings set $setting
done

# Some custom Gnome extensions settings which modify the use of the desktop environment
dconf write /org/gnome/shell/extensions/dash-to-dock/hot-keys false
dconf write /org/gnome/shell/extensions/dash-to-dock/intellihide-mode "'ALL_WINDOWS'"
dconf write /org/gnome/shell/extensions/dash-to-dock/running-indicator-style "'DASHES'"
dconf write /org/gnome/shell/extensions/dash-to-dock/clock-action "'focus-minimize-or-previews'"
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size "64"
dconf write /org/gnome/shell/extensions/dash-to-dock/intellihide-mode "'ALL_WINDOWS'"

dconf write /org/gnome/shell/extensions/bingwallpaper/delete-previous true
dconf write /org/gnome/shell/extensions/bingwallpaper/selected-image "'current'"

dconf write /org/gnome/shell/extensions/tiling-assistant/activate-layout0 "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/activate-layout1 "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/activate-layout2 "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/activate-layout3 "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/auto-tile "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/center-window "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/restore-window "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/search-popup-layout "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-bottom-half "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-topleft-quarter "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-topright-quarter "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-bottomleft-quarter "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-bottomright-quarter "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-top-half "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-edit-mode "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-left-half "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-right-half "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-maximize "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-maximize-horizontally "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/tile-maximize-vertically "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/toggle-always-on-top "[]"
dconf write /org/gnome/shell/extensions/tiling-assistant/toggle-tiling-popup "[]"
