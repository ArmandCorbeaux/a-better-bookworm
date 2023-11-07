#!/bin/bash

################################################################################
# 6 - INSTALL SOME USEFUL TOOLS NOT INSTALLED BY DEFAULT
################################################################################
#
# Job :     install some useful tools
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  whole system
#
# Inputs :  USEFUL_TOOLS
# Outputs : APT
#
# More informations :
#   cups :                  add printers support
#   curl :                  command line tool and library for transferring data with URLs (since 1998)
#   git :                   distributed version control system designed to handle everything from small to very large projects with speed and efficiency
#   python3-venv :          support for creating lightweight "virtual environments", needed to install a non-Debian-packaged Python package in Debian 12 Bookworm
#   python3-pip :           package installer for Python
#   gnome-disk-utility :    useful to graĥically see space use or create an usb key

# Function to install package
execute_commands() {
    if [ $# -eq 0 ]; then
        return
    fi
    sudo apt-get install -y $1 > /dev/null
    shift
    execute_commands "$@"
}

USEFUL_TOOLS=(
    "cups"
    "curl"
    "git"
    "python3-venv"
    "python3-pip"
    "gnome-disk-utility"
)

# Update packages list
sudo apt-get update > /dev/null

# Install packages
execute_commands "${USEFUL_TOOLS[@]}"