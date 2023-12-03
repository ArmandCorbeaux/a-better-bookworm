#!/bin/bash

################################################################################
# 501 - SYSTEMCTL PER USER
################################################################################
#
# Job :     Enable custom services for current user
#
# Author :  Armand CORBEAUX
# Date :    2023-11-30
#
# Impact :  system-wide
#
# Inputs :  
# Outputs : 
#
# More informations :
#           
# Bugs :
#           
SCRIPT_CONTENT=$(cat <<EOF
#!/bin/bash

# Define the services to check
services=(onedrive docker-desktop)

# Get a list of human users, excluding system users and root
human_users=$(getent passwd | awk -F: '($1 != "root" && $7 == "/bin/bash") {print $1}')
echo $human_users

# Iterate over human users
for user in $human_users; do
    # Check if each service is enabled for the current user
    for service in "${services[@]}"; do
        if ! systemctl --user --exists "$service.service"; then
            echo "Enabling service $service for user $user"
            systemctl --user enable "$service"
        fi
    done
done
EOF
)

printf '%s\n' "$SCRIPT_CONTENT" | sudo tee "/etc/systemd/system/enable-specific-services.sh" &> /dev/null
sudo chmod +x "/etc/systemd/system/enable-specific-services.sh"

SERVICE_FILE_CONTENT="[Unit]
Description=Enable Services for Users

[Service]
Type=oneshot
ExecStart=/etc/systemd/system/enable-specific-services.sh

[Install]
WantedBy=multi-user.target
"

SERVICE_FILE_PATH="/etc/systemd/system/enable-specific-services.service"

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
  sudo systemctl enable enable-specific-services.service &> /dev/null
  sudo systemctl start enable-specific-services.service &> /dev/null

  echo "enable-specific-services created and enabled."
else
  echo "enable-specific-services is already up to date."
fi
