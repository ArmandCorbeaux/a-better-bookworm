#!/bin/bash

################################################################################
# 711 - Install MoreWaita icon theme
################################################################################
#
# Job :     Install icon pack
#
# Author :  Armand CORBEAUX
# Date :    2023-11-14
#
# Impact :  system
#
# Inputs :  MORAWAITA_GITHUB_URL,
# Outputs : /usr/share/icons
#
# More informations :
#           https://github.com/somepaulo/MoreWaita
#           Adwaita styled companion icon theme with extra icons for popular apps to fit with Gnome Shell's original icons.
#           The purpose of this theme is to provide third-party apps with a consistent look and feel in Gnome Shell.

MOREWAITA_GITHUB_URL="https://github.com/somepaulo/MoreWaita.git"

# MoreWaita icon theme install
git clone $MOREWAITA_GITHUB_URL
sudo ./MoreWaita/install.sh
rm -Rf MoreWaita