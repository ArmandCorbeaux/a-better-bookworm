#!/bin/bash

################################################################################
# 751 - Custom GDM3 settings
################################################################################
#
# Job :     Personalize GDM3 experience
#
# Author :  Armand CORBEAUX
# Date :    2023-11-15
#
# Impact :  system wide
#
# Inputs :  SETTINGS
# Outputs : FILE, CONFIG_FILE
#
# More informations :
#           customize GDM3 settings to match gnome desktop theme

# Define the file to be edited
FILE="/etc/gdm3/greeter.dconf-defaults"

# Remove accessibility icon in GDM
CONFIG_FILE="/usr/share/gdm/dconf/00-upstream-settings"
SECTION="[org/gnome/desktop/a11y]"
KEY="always-show-universal-access-status"
NEW_VALUE="false"

# Use sed to make the desired changes
sudo sed -i '/\[org\/gnome\/desktop\/interface\]/a\
cursor-theme='\''Bibata-Modern-Amber'\''\
icon-theme='\''MoreWaita'\''\
document-font-theme='\''Cantarell 11'\''\
font-theme='\''Cantarell 11'\''\
clock-show-seconds=true\
clock-show-weekday=true\
font-antialiasing='\''rgba'\''\
font-hinting='\''full'\''\
' "$FILE"

# Use sed to modify the key in the specific section of the config file
sudo sed -i "/$SECTION]/,/^$/ s/\($KEY\s*=\s*\).*/\1$NEW_VALUE/" "$CONFIG_FILE"

sudo dpkg-reconfigure gdm3 &> /dev/null
