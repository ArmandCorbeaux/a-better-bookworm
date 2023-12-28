#!/bin/bash

################################################################################
# 002 - APT - SOURCES.LIST - ADD CONTRIB AND NON-FREE ENTRIES
################################################################################
#
# Job :     add contrib and non-free entries on /etc/apt.sources.list
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
#           https://wiki.debian.org/SourcesList

TARGET="/etc/apt/sources.list"

# Create a new sources.list.tmp file to store the modified contents
sudo cp $TARGET $TARGET.tmp

# Flag to track if modifications are made
modifications_made=false

# Iterate over the lines in the original sources.list file
while IFS= read -r line; do

  # If the line starts with deb or deb-src
  if [[ $line =~ ^deb.* ]]; then

    # Check if contrib non-free is already in the line
    if [[ ! $line =~ "contrib non-free" ]]; then

      # Add contrib non-free to the line
      modified_line="$line contrib non-free"

      # Replace the original line with the modified line in the temporary file
      sudo sed -i "s|$line|$modified_line|" $TARGET.tmp

      # Set the modifications flag to true
      modifications_made=true

    fi

  fi

done < $TARGET

# Check if sources.list has been modified and performs operations if it's the case
if [ "$modifications_made" = true ]; then

  # Replace the original sources.list file with the modified temporary file
  sudo mv $TARGET.tmp $TARGET

  echo "Changes performed in $TARGET"

else

  sudo rm $TARGET.tmp

  echo "No changes performed in $TARGET"

fi