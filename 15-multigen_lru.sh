#!/bin/bash

################################################################################
# 15 - Enable Multi-Gen LRU kernel feature as a service
################################################################################

# https://docs.kernel.org/admin-guide/mm/multigen_lru.html

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
echo "$SERVICE_FILE_CONTENT" | sudo tee "$SERVICE_FILE_PATH" > /dev/null

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable and start the mglru service
sudo systemctl enable mglru.service
sudo systemctl start mglru.service

echo "mglru.service created and enabled."