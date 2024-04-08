#!/bin/bash

################################################################################
# 101 - CHANGE BTRFS FLAGS IN FSTAB
################################################################################
#
# Job :     changes settings in /etc/fstab if a btrfs partition is used
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  system wide
#
# Inputs :  TARGET
# Outputs : TARGET
#
# More informations :
#           Settings are optimized for electronic storage :
#           discard=async:  Enables the TRIM command, which helps to keep SSD clean and maintain its performance over time.
#           autodefrag:     Automatically defragments files on the fly, which can help to improve performance.
#           compress=zstd:  Enables transparent compression of files, which can help to save disk space.
#           commit=120:     Sets the interval between committing changes to the file system to 120 seconds.
#                           Help to improve performance by reducing the number of writes to the disk.

FSTAB_PATH="/etc/fstab"

# Flag to track if modifications are made
modifications_made=false

# Check each line in /etc/fstab

while IFS= read -r line; do
  if [[ "$line" == *"btrfs"* ]] && [[ "$line" == *"defaults"* ]]; then

    # Replace 'defaults' with 'ssd,discard=async,autodefrag,compress=zstd,commit=120'
    
    updated_line=$(echo "$line" | sed 's/defaults/ssd,discard=async,autodefrag,compress=zstd,noatime,commit=120/')

    # Use sudo to update the file    
    sudo sed -i "s|$line|$updated_line|" $FSTAB_PATH

    # Set changes_made to true
    modifications_made=true

  fi

done < $FSTAB_PATH

# Check if changes were made and echo appropriate message

if [ "$modifications_made" = true ]; then

  echo "Changes performed in $FSTAB_PATH"

else

  echo "No changes performed in $FSTAB_PATH"

fi
