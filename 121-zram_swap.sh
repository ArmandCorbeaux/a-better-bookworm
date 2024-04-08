#!/bin/bash

################################################################################
# 121 - ADD ZRAMSWAP
################################################################################
#
# Job :     Enable zRAM as compressed memory swap space
#
# Author :  Armand CORBEAUX
# Date :    2023-11-15
#
# Impact :  system wide
#
# Inputs :  ZRAM_ALGO, ZRAM_PERCENT, ZRAM_PRIORITY
#           SYSCTL_VALUES
#           ZRAM_TARGET, SYSCTL_TARGET
# Outputs : ZRAM_TARGET, SYSCTL_TARGET
#
# More informations :
#           https://en.wikipedia.org/wiki/Zram
#           Settings are very aggresive

# Values in zramswap
ZRAM_ALGO="zstd"
ZRAM_PERCENT=400
ZRAM_PRIORITY=180

# Values in sysctl.conf
SYSCTL_VALUES=(
  "vm.page-cluster=0"
  "vm.swappiness=180"
  "vm.watermark_boost_factor=0"
  "vm.watermark_scale_factor=125"
  "vm.max_map_count = 2147483642"
)

# Files location
ZRAM_TARGET="/etc/default/zramswap"
SYSCTL_TARGET="/etc/sysctl.conf"

# Function to check if a file contains a specific line
file_contains_line() {
  local file="$1"
  local line="$2"
  grep -q "^$line$" "$file"
}

# Function to update a line in a file or append it if not present
update_or_append_line() {
  local file="$1"
  local line="$2"
  if file_contains_line "$file" "$line"; then
    echo "Line already exists in $file: $line"
  else
    echo "$line" | sudo tee -a "$file" &> /dev/null
    echo "Added line to $file: $line"
  fi
}

# Check and install ZRAM
if ! command -v zramctl &> /dev/null; then
  sudo apt update &> /dev/null
  sudo apt install zram-tools -y &> /dev/null
fi

# Check and update ZRAM settings
update_or_append_line "$ZRAM_TARGET" "ALGO=\"$ZRAM_ALGO\""
update_or_append_line "$ZRAM_TARGET" "PERCENT=$ZRAM_PERCENT"
update_or_append_line "$ZRAM_TARGET" "PRIORITY=$ZRAM_PRIORITY"

# Check and update sysctl.conf
for value in "${SYSCTL_VALUES[@]}"; do
  update_or_append_line "$SYSCTL_TARGET" "$value"
done

echo "zRAM enabled."