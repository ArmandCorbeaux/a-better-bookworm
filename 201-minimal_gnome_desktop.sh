#!/bin/bash

################################################################################
# 201 - INSTALL MINIMAL GNOME DESKTOP
################################################################################
#
# Job :     install a minimal but functional Gnome Desktop environment
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  system wide
#
# Inputs :  PACKAGES
# Outputs : apt
#
# More informations :
#           https://packages.debian.org/bookworm/gnome-shell
#           gnome-console :         Not the main terminal. Used by onedrive and docker-desktop
#           gnome-tweaks :          used to access to advanced customization desktop settings
#           nautilus :              known as "Files", graphical file manager
#           gnome-disk-utility :    useful to graĥically see space use or create an usb key           

# Packages to install
PACKAGES="gnome-shell gnome-console gnome-tweaks nautilus gnome-disk-utility"

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

  # Garbage packages cleanup
  # Don't need 'gnome-shell-extension-prefs' as 'gnome-shell-extension-manager' will be installed and has more functions
  sudo apt-get autoremove --purge gnome-shell-extension-prefs -y &> /dev/null

  echo "Installation complete."
else
  echo "Packages are already installed."
fi