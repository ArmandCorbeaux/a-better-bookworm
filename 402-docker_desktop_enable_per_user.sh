#!/bin/bash

################################################################################
# 402 - APT - DOCKER DESKTOP
################################################################################
#
# Job :     Enable Docker-Desktop service
#
# Author :  Armand CORBEAUX
# Date :    2023-11-14
#
# Impact :  user
#
# Inputs :  systemctl
# Outputs : systemd
#
# More informations :
#           https://docs.docker.com/desktop/faqs/linuxfaqs/#why-does-docker-desktop-for-linux-run-a-vm
#           https://docs.docker.com/desktop/install/linux-install/
#           Docker Desktop for Linux runs a Virtual Machine (VM).
#
# Bugs :
#           It's a per-user service

# Enable Docker-Desktop Services
systemctl --user enable docker-desktop &> /dev/null