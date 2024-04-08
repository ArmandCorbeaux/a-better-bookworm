#!/bin/bash

################################################################################
# 131 - Multi-Gen LRU kernel feature
################################################################################
#
# Job :     Enable Multi-Gen LRU kernel feature as a service
#
# Author :  Armand CORBEAUX
# Date :    2023-11-13
#
# Impact :  system wide
#
# Inputs :  SERVICE_FILE_CONTENT, SERVICE_FILE_PATH
# Outputs : SERVICE_FILE_PATH, systemctl
#
# More informations :
#           https://docs.kernel.org/admin-guide/mm/multigen_lru.html
#           Settings must be applied as each boot


SERVICE_FILE_CONTENT="[Unit]
Description=Multi-Gen LRU Enabler Service
ConditionPathExists=/sys/kernel/mm/lru_gen/enabled

[Service]
Type=oneshot
ExecStart=/bin/sh -c \"echo 'y' > /sys/kernel/mm/lru_gen/enabled && echo '1000' > /sys/kernel/mm/lru_gen/min_ttl_ms\"

[Install]
WantedBy=default.target
"

SERVICE_FILE_PATH="/etc/systemd/system/mglru.service"

# Function to check if a file contains a specific content
file_contains_content() {
  local file="$1"
  local content="$2"
  grep -q "$content" "$file" &> /dev/null
}

# Check if the service file needs to be updated
if ! file_contains_content "$SERVICE_FILE_PATH" "$SERVICE_FILE_CONTENT"; then
  # Save the service file content to the specified location
  echo "$SERVICE_FILE_CONTENT" | sudo tee "$SERVICE_FILE_PATH" &> /dev/null

  # Reload systemd to recognize the new service
  sudo systemctl daemon-reload &> /dev/null

  # Enable and start the mglru service
  sudo systemctl enable mglru.service &> /dev/null
  sudo systemctl start mglru.service &> /dev/null

  echo "mglru.service created and enabled."
else
  echo "mglru.service is already up to date."
fi
