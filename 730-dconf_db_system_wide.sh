#!/bin/bash
DCONF_USER_FILENAME="/etc/dconf/profile/user"
DCONF_USER_PATH="/etc/dconf/profile"

DCONF_FILE_CONTENT=$(cat <<EOF
user-db:user
system-db:system-wide
EOF
)

sudo mkdir -p $DCONF_USER_PATH
echo "$DCONF_FILE_CONTENT" | sudo tee "$DCONF_USER_FILENAME"
