#!/bin/bash

################################################################################
# 733 - Custom Gnome Shell settings
################################################################################
#
# Job :     Personalize Gnome Shell experience
#
# Author :  Armand CORBEAUX
# Date :    2023-12-28
#
# Impact :  system wide
#
# Inputs :  DCONF_USER_FILENAME, DCONF_USER_PATH, DCONF_FILE_CONTENT
# Outputs : DCONF_USER_FILENAME
#
# More informations :
#           Create dconf profile to apply to each user custom settings
#

DCONF_USER_FILENAME="/etc/dconf/profile/user"
DCONF_USER_PATH="/etc/dconf/profile"

DCONF_FILE_CONTENT=$(cat <<EOF
user-db:user
system-db:system-wide
EOF
)

sudo mkdir -p $DCONF_USER_PATH
echo "$DCONF_FILE_CONTENT" | sudo tee "$DCONF_USER_FILENAME"
