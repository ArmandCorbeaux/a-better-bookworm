#!/bin/bash

################################################################################
# 211 - PRINTER SUPPORT
################################################################################
#
# Job :     Add printer support
#
# Author :  Armand CORBEAUX
# Date :    2023-11-08
#
# Impact :  system wide
#
# Inputs :  USEFUL_TOOLS
# Outputs : apt
#
# More informations :
#   cups :                  add printers support

# PAckages to install
USEFUL_TOOLS=(
    "cups"
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