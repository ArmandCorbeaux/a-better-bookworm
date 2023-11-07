#!/bin/bash

################################################################################
# 19 - Custom Gnome 43 settings
################################################################################

# customize GDM3 settings to match gnome desktop theme
echo "customize GDM3 login interface"


# Define the file to be edited
file="/etc/gdm3/greeter.dconf-defaults"

# Use sed to make the desired changes
sudo sed -i '/\[org\/gnome\/desktop\/interface\]/a\
cursor-theme='\''Bibata-Modern-Amber'\''\
icon-theme='\''MoreWaita'\''\
document-font-theme='\''Cantarell 11'\''\
font-theme='\''Cantarell 11'\''\
clock-show-seconds=true\
clock-show-weekday=true\
font-antialiasing='\''grayscale'\''\
font-hinting='\''slight'\''\
' "$file"


# Disable accessibility icon in gdm

# Define the config file, section, key, and new value
config_file="/usr/share/gdm/dconf/00-upstream-settings"
section="[org/gnome/desktop/a11y]"
key="always-show-universal-access-status"
new_value="false"

# Use sed to modify the key in the specific section of the config file
sudo sed -i "/$section]/,/^$/ s/\($key\s*=\s*\).*/\1$new_value/" "$config_file"

sudo dpkg-reconfigure gdm3
