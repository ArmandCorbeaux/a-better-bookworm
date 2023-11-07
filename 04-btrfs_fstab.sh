#!/bin/bash

################################################################################
# 04 - CHANGE BTRFS FLAGS IN FSTAB
################################################################################
#
# Job :     changes settings in /etc/fstab if a btrfs partition is used
#
# Author :  Armand CORBEAUX
# Date :    2023-11-07
#
# Impact :  whole system
#
# Inputs :  TARGET
# Outputs : TARGET
#
# More informations :
#   Settings are optimized for electronic storage :
#     discard=async:  enables the TRIM command, which helps to keep SSD clean and maintain its performance over time.
#     autodefrag:     automatically defragments files on the fly, which can help to improve performance.
#     compress=zstd:  enables transparent compression of files, which can help to save disk space.
#     commit=120:     sets the interval between committing changes to the file system to 120 seconds.
#                     help to improve performance by reducing the number of writes to the disk.

TARGET="/etc/fstab"

# Flag to track if modifications are made
modifications_made=false

# Check each line in /etc/fstab

while IFS= read -r line; do
  if [[ "$line" == *"btrfs"* ]] && [[ "$line" == *"defaults"* ]]; then

    # Replace 'defaults' with 'ssd,discard=async,autodefrag,compress=zstd,commit=120'
    
    updated_line=$(echo "$line" | sed 's/defaults/ssd,discard=async,autodefrag,compress=zstd,noatime,commit=120/')

    # Use sudo to update the file    
    sudo sed -i "s|$line|$updated_line|" $TARGET

    # Set changes_made to true
    modifications_made=true

  fi

done < $TARGET

# Check if changes were made and echo appropriate message

if [ "$modifications_made" = true ]; then

  echo "Changes performed in $TARGET"

else

  echo "No changes performed in $TARGET"

fi
