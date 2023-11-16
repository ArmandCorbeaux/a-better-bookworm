#!/bin/bash

################################################################################
# 111 - CUSTOMIZE BOOT SPEED AND LOOK
################################################################################
#
# Job :     Change boot style and enable amd_pstate if AMD CPU
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  system
#
# Inputs :  PLYMOUTH_THEME
#           NEW_GRUB_TIMEOUT, NEW_GRUB_CMDLINE_LINUX_DEFAULT, NEW_GRUB_BACKGROUND
#           GRUB_PATH
# Outputs : plymouth, GRUB_PATH
#
# More informations :
#           GRUB :      Remove wait time at boot
#           GRUB :      Enable splash screen
#           Kernel :    if AMD CPU and pstate supported, add commands to enable amd_pstate on kernel 6.1
#           Plymouth :  Theme with OEM Bios logo

# Customize GRUB values
NEW_GRUB_TIMEOUT=0  # Immediatly load the kernel
NEW_GRUB_CMDLINE_LINUX_DEFAULT="fsck.mode=skip quiet splash loglevel=3"  # Show plymouth theme and enable AMD P-State module
NEW_GRUB_BACKGROUND=""  # No background
# GRUB file path
GRUB_PATH="/etc/default/grub"

# Splash theme to enable
PLYMOUTH_THEME="bgrt"

# Check if the CPU is AMD and support 'pstate' to enable module
if [[ $(cat /proc/cpuinfo | grep vendor_id | uniq) == *"AuthenticAMD"* ]] && [[ $(cat /proc/cpuinfo | grep flags | uniq) == *"pstate"* ]]; then
  NEW_GRUB_CMDLINE_LINUX_DEFAULT+=" amd_pstate=passive amd_pstate.shared_mem=1"
  echo "AMD CPU with 'pstate' detected. Specific settings will be applied"
fi

# Update packages list
sudo apt update &> /dev/null

# Install plymouth-themes
sudo apt install plymouth-themes -y &> /dev/null

# Set theme to use OEM Bios Logo
sudo plymouth-set-default-theme -R bgrt

# Change the GRUB_TIMEOUT value
sudo sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$NEW_GRUB_TIMEOUT/" $GRUB_PATH

# Change the GRUB_CMDLINE_LINUX_DEFAULT value
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_GRUB_CMDLINE_LINUX_DEFAULT\"/" $GRUB_PATH

# Change or add the GRUB_BACKGROUND value
if grep -q "^GRUB_BACKGROUND=" $GRUB_PATH; then
  sudo sed -i "s/GRUB_BACKGROUND=.*/GRUB_BACKGROUND=\"$NEW_GRUB_BACKGROUND\"/" $GRUB_PATH
else
  echo "GRUB_BACKGROUND=\"$NEW_GRUB_BACKGROUND\"" | sudo tee -a $GRUB_PATH &> /dev/null
fi

# Update GRUB settings to enable changes
sudo update-grub &> /dev/null
