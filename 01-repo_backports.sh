#!/bin/bash

################################################################################
# 01 - APT - SOURCES.LIST - ADD BACKPORTS REPOSITORY
################################################################################
#
# Job :     add backports repositories on /etc/apt.sources.list
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  whole system
# 
# Inputs :  dist_codename, TARGET
# Outputs : TARGET
#
# More informations :
#   https://backports.debian.org/

TARGET="/etc/apt/sources.list"

# Get distribution codename
dist_codename=$(lsb_release -sc)

# Check if backports entry already exists in sources.list
if sudo grep -q "$dist_codename-backports" $TARGET; then
  echo "No changes performed in $TARGET"

else

    # Add the backports repository entry to sources.list
    echo "deb http://deb.debian.org/debian $dist_codename-backports main non-free-firmware" | sudo tee -a $TARGET > /dev/null
    echo "deb-src http://deb.debian.org/debian $dist_codename-backports main non-free-firmware" | sudo tee -a $TARGET.list > /dev/null

    echo "Changes performed in $TARGET"
fi