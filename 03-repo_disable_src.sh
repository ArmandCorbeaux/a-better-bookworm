#!/bin/bash

################################################################################
# 03 - APT - SOURCES.LIST - DISABLE DEB-SRC LINES
################################################################################
#
# Job :     add # at the beginning of each deb-src lines
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
#   https://wiki.debian.org/SourcesList

TARGET="/etc/apt/sources.list"

# Temp file to store modified lines
temp_file=$(mktemp)

# Flag to track if modifications are made
modifications_made=false

# Read the sources.list file line by line
while IFS= read -r line; do
  
  # If the line starts with deb-src  
  if [[ $line =~ ^deb-src.* ]]; then
  
    # Add # to the beginning of the line
    echo "#$line" >> "$temp_file"
    
    # Set changes_made to true0
    modifications_made=true

  else

    echo "$line" >> "$temp_file"

  fi

done < $TARGET

# Check if sources.list has been modified and performs operations if it's the case
if [ "$modifications_made" = true ]; then

  # Replace the original file with the modified content
  sudo mv $temp_file $TARGET
  
  echo "Changes performed in $TARGET"

else

  # No changes were made
  rm $temp_file

  echo "No changes performed in $TARGET"

fi
