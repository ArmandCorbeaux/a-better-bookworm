#!/bin/bash
FILE_PATH="/etc/dconf/db/ibus.d/743-gnome_shell_extensions_settings"

SETTINGS=$(cat <<EOF
[org/gnome/shell]
enabled-extensions=@as ['BingWallpaper@ineffable-gmail.com', 'onedrive@diegomerida.com', 'dash-to-dock@micxgx.gmail.com', 'appindicatorsupport@rgcjonas.gmail.com', 'tiling-assistant@leleat-on-github', 'caffeine@patapon.info']

[org/gnome/shell/extensions/dash-to-dock]
hot-keys=false
intellihide-mode='ALL_WINDOWS'
running-indicator-style='DASHES'
clock-action='focus-minimize-or-previews'
dash-max-icon-size=64

[org/gnome/shell/extensions/bingwallpaper]
delete-previous=true
selected-image='current'

[org/gnome/shell/extensions/tiling-assistant]
restore-window=@as []
tile-bottom-half=@as []
tile-topleft-quarter=@as []
tile-topright-quarter=@as []
tile-bottomleft-quarter=@as []
tile-bottomright-quarter=@as []
tile-top-half=@as []
tile-left-half=@as []
tile-right-half=@as []
tile-maximize=@as []
EOF
)

echo "$SETTINGS" | sudo tee "$FILE_PATH"

sudo dconf update