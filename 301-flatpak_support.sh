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
# Impact :  system
#
# Inputs :  APT, flatpak
# Outputs : APT, flatpak
#
# More informations :
#           https://flatpak.org/
#           https://flathub.org/about
#           Flatpak is a sandboxed application package format, promoted by Gnome and KDE.
#           Through Flatpak, users have access to newer applications releases.
#           https://docs.flatpak.org/en/latest/using-flatpak.html
#           The applications catalogue in gnome-software is also extended.
#           If available, users have the choice between deb ou flatpak packages

# Update packages list
sudo apt update

# Install flatpak gnome-software plugin
sudo apt install gnome-software-plugin-flatpak -y

# Add Flahub repository
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Fluch content of the repository
flatpak update