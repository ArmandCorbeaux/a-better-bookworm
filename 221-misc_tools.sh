#!/bin/bash

################################################################################
# 221 - INSTALL SOME USEFUL TOOLS NOT INSTALLED BY DEFAULT
################################################################################
#
# Job :     install some useful tools
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  system
#
# Inputs :  USEFUL_TOOLS
# Outputs : APT
#
# More informations :
#   curl :                  command line tool and library for transferring data with URLs (since 1998)
#   git :                   distributed version control system designed to handle everything from small to very large projects with speed and efficiency

# Packages to install
USEFUL_TOOLS=(
    "curl"
    "git"
)

# Function to install package
execute_commands() {
    if [ $# -eq 0 ]; then
        return
    fi
    sudo apt-get install -y $1 &> /dev/null
    shift
    execute_commands "$@"
}

# Update packages list
sudo apt-get update &> /dev/null

# Install packages
execute_commands "${USEFUL_TOOLS[@]}"