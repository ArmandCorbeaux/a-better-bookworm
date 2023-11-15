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
# Impact :  system
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

# Save the service file content to the specified location
echo "$SERVICE_FILE_CONTENT" | sudo tee "$SERVICE_FILE_PATH" > &/dev/null

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable and start the mglru service
sudo systemctl enable mglru.service
sudo systemctl start mglru.service

echo "mglru.service created and enabled."