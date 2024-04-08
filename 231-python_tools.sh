#!/bin/bash

################################################################################
# 231 - INSTALL SOME USEFUL TOOLS NOT INSTALLED BY DEFAULT
################################################################################
#
# Job :     install some useful tools
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  system wide
#
# Inputs :  USEFUL_TOOLS
# Outputs : apt
#
# More informations :
#   python3-venv :          support for creating lightweight "virtual environments", needed to install a non-Debian-packaged Python package in Debian 12 Bookworm
#   python3-pip :           package installer for Python, uwed by python3-venv

# Packages to install
USEFUL_TOOLS=(
    "python3-venv"
    "python3-pip"
)

# Function to install package
execute_commands() {
    if [ $# -eq 0 ]; then
        return
    fi
    echo "Install $1"
    sudo apt-get install -y $1 &> /dev/null
    shift
    execute_commands "$@"
}

# Update packages list
sudo apt-get update &> /dev/null

# Install packages
execute_commands "${USEFUL_TOOLS[@]}"