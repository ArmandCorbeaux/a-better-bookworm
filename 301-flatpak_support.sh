#!/bin/bash

################################################################################
# 301 - FLATPAK - ADD SOFTWARE STORE
################################################################################
#
# Job :     Enable Flatpak support and Flathub repository
#
# Author :  Armand CORBEAUX
# Date :    2023-11-08
#
# Impact :  system wide
#
# Inputs :  PACKAGE, flatpak
# Outputs : apt, flatpak
#
# More informations :
#           https://flatpak.org/
#           https://flathub.org/about
#           Flatpak is a sandboxed application package format, promoted by Gnome and KDE.
#           Through Flatpak, users have access to newer applications releases.
#           https://docs.flatpak.org/en/latest/using-flatpak.html
#           The applications catalogue in gnome-software is also extended.
#           If available, users have the choice between deb ou flatpak packages


# Packages to install
PACKAGES=" gnome-software-plugin-flatpak"

# Function to check if a package is installed
package_installed() {
  local package="$1"
  dpkg -l | grep -q "^ii.*$package"
}

# Update packages list
sudo apt-get update &> /dev/null

# Check if the packages are already installed
missing_packages=()
for pkg in $PACKAGES; do
  if ! package_installed "$pkg"; then
    missing_packages+=("$pkg")
  fi
done

# Install missing packages
if [ ${#missing_packages[@]} -gt 0 ]; then
  echo "Install ${missing_packages[*]}"
  sudo apt-get install "${missing_packages[@]}" -y &> /dev/null

  echo "Installation complete."
else
  echo "Packages are already installed."
fi

# Add Flahub repository
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Fluch content of the repository
flatpak update