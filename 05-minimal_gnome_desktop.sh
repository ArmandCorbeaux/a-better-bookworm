#!/bin/bash

################################################################################
# 05 - INSTALL MINIMAL GNOME DESKTOP
################################################################################
#
# Job :     install a minimal but functional Gnome Desktop environment
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  whole system
#
# Inputs :  PACKAGES
# Outputs : APT
#
# More informations :
#   https://packages.debian.org/bookworm/gnome-shell

PACKAGES="gnome-shell gnome-console gnome-tweaks nautilus"

# Update packages list
sudo apt-get update > /dev/null

echo "Install $PACKAGES"
sudo apt-get install $PACKAGES -y

# Garbage packages cleanup
# Don't need 'gnome-shell-extension-prefs' as 'gnome-shell-extension-manager' will be installed and performs the same stuff
sudo apt-get autoremove --purge gnome-shell-extension-prefs -y > /dev/null