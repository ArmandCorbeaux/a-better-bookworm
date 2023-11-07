#!/bin/bash

################################################################################
# 09 - FLATPAK - ADD SOFTWARE STORE
################################################################################
#
# Job :     Enable Flatpak support and Flathub repository
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  whole system
#
# Inputs :  APT, flatpak
# Outputs : APT, flatpak
#
# More informations :
#   https://flatpak.org/
#   https://flathub.org/about

# Update packages list
sudo apt update

# Install flatpak gnome-software plugin
sudo apt install gnome-software-plugin-flatpak -y

# Add Flahub repository
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Fluch content of the repository
sudo flatpak update